<#
.SYNOPSIS
  Watcher R1+R2+R3: poll handoff dir, console notify, optional Toast, state, lock.

.DESCRIPTION
  Polls docs/handoffs/codex-cursor for stable *-instruction.md / *-result.md /
  *-judgement.md files. Default channel is console. Does not execute instructions,
  call APIs, commit, push, or make network requests.

  Spec: docs/codex-cursor-watcher-mvp.md (R1 + R2 + R3)
  - R1: poll + debounce + ignore templates + console notify
  - R2: persistent .watcher-state.json + .watcher.lock single-instance
  - R3: optional -Toast desktop tip; on failure fall back to console only

.PARAMETER WatchDir
  Absolute or relative path to the handoff directory.

.PARAMETER PollSeconds
  Poll interval in seconds (default 0.5).

.PARAMETER DebounceSeconds
  Require size+mtime unchanged for this many seconds before notify (default 1.5).

.PARAMETER DurationSeconds
  Stop after N seconds. 0 = run until Ctrl+C (default 0).

.PARAMETER RequireHeading
  If set, only notify when file body contains the expected ## heading.

.PARAMETER StateFile
  Override path to persistent state JSON (default: <WatchDir>/.watcher-state.json).

.PARAMETER LockFile
  Override path to lock file (default: <WatchDir>/.watcher.lock).

.PARAMETER ForceUnlock
  If set, delete a stale/foreign lock before acquiring (use only when sure no other watcher runs).

.PARAMETER Toast
  Optional Windows toast/balloon tip in addition to console. Default off.
  Toast failures are logged and never abort the watcher.
#>
param(
    [string]$WatchDir = '',
    [double]$PollSeconds = 0.5,
    [double]$DebounceSeconds = 1.5,
    [int]$DurationSeconds = 0,
    [switch]$RequireHeading,
    [string]$StateFile = '',
    [string]$LockFile = '',
    [switch]$ForceUnlock,
    [switch]$Toast
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($WatchDir)) {
    $WatchDir = Join-Path $PSScriptRoot '..\docs\handoffs\codex-cursor'
}

$WatchDir = [System.IO.Path]::GetFullPath($WatchDir)
if (-not (Test-Path -LiteralPath $WatchDir -PathType Container)) {
    throw "Watch directory not found: $WatchDir"
}

if ([string]::IsNullOrWhiteSpace($StateFile)) {
    $StateFile = Join-Path $WatchDir '.watcher-state.json'
}
else {
    $StateFile = [System.IO.Path]::GetFullPath($StateFile)
}

if ([string]::IsNullOrWhiteSpace($LockFile)) {
    $LockFile = Join-Path $WatchDir '.watcher.lock'
}
else {
    $LockFile = [System.IO.Path]::GetFullPath($LockFile)
}

$script:Notified = @{}
$script:Pending = @{}
$script:LockAcquired = $false
$script:LockFilePath = $LockFile
$script:StateFilePath = $StateFile

function Write-WatchLog {
    param([string]$Level, [string]$Message)
    $ts = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    Write-Host "[$ts] [$Level] $Message"
}

function Test-IgnoredName {
    param([string]$Name)
    if ($Name -eq 'README.md') { return $true }
    if ($Name -like '_template-*.md') { return $true }
    if ($Name -like '*.tmp') { return $true }
    if ($Name.StartsWith('~')) { return $true }
    if ($Name -like '.watcher-*') { return $true }
    return $false
}

function Get-HandoffType {
    param([string]$Name)
    if ($Name -match '-instruction\.md$') { return 'instruction' }
    if ($Name -match '-result\.md$') { return 'result' }
    if ($Name -match '-judgement\.md$') { return 'judgement' }
    return $null
}

function Get-TaskMeta {
    param([string]$Name)
    if ($Name -match '^(?<id>.+)-r(?<round>\d{2})-(instruction|result|judgement)\.md$') {
        return @{ TaskId = $Matches['id']; Round = $Matches['round'] }
    }
    return @{ TaskId = '?'; Round = '??' }
}

function Get-Hint {
    param([string]$Type)
    switch ($Type) {
        'instruction' { return 'Open in Cursor and execute this instruction' }
        'result' { return 'Pass RESULT to Codex for judgement' }
        'judgement' { return 'Judgement landed; close out or start next round' }
        default { return 'Inspect handoff file' }
    }
}

function Test-ExpectedHeading {
    param(
        [string]$Path,
        [string]$Type
    )
    if (-not $RequireHeading) { return $true }
    $need = switch ($Type) {
        'instruction' { '## CODEX_INSTRUCTION' }
        'result' { '## CURSOR_RESULT' }
        'judgement' { '## CODEX_JUDGEMENT' }
        default { $null }
    }
    if (-not $need) { return $true }
    try {
        $head = Get-Content -LiteralPath $Path -TotalCount 80 -ErrorAction Stop
        return ($null -ne ($head | Where-Object { $_ -like "$need*" -or $_ -eq $need }))
    }
    catch {
        return $false
    }
}

function Get-NotifyKey {
    param(
        [string]$Path,
        [long]$Size,
        [datetime]$MtimeUtc
    )
    $rel = $Path
    try {
        if ($Path.StartsWith($WatchDir, [System.StringComparison]::OrdinalIgnoreCase)) {
            $rel = $Path.Substring($WatchDir.Length).TrimStart('\', '/')
        }
    }
    catch { }
    return "$rel|$Size|$($MtimeUtc.Ticks)"
}

function Show-WatcherToast {
    param(
        [string]$Title,
        [string]$Body
    )
    if (-not $Toast) { return }

    $escTitle = [System.Security.SecurityElement]::Escape($Title)
    $escBody = [System.Security.SecurityElement]::Escape($Body)

    # 1) Prefer WinRT Toast (no extra modules)
    try {
        $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
        $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime]
        $xml = @"
<toast><visual><binding template="ToastGeneric"><text>$escTitle</text><text>$escBody</text></binding></visual></toast>
"@
        $doc = New-Object Windows.Data.Xml.Dom.XmlDocument
        $doc.LoadXml($xml)
        $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
        $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId)
        $notification = [Windows.UI.Notifications.ToastNotification]::new($doc)
        $notifier.Show($notification)
        return
    }
    catch {
        Write-WatchLog 'DEBUG' "WinRT toast unavailable: $($_.Exception.Message)"
    }

    # 2) Balloon tip fallback (still no new dependencies)
    try {
        Add-Type -AssemblyName System.Windows.Forms | Out-Null
        Add-Type -AssemblyName System.Drawing | Out-Null
        $ni = New-Object System.Windows.Forms.NotifyIcon
        $ni.Icon = [System.Drawing.SystemIcons]::Information
        $ni.Visible = $true
        $tipBody = $Body
        if ($tipBody.Length -gt 240) { $tipBody = $tipBody.Substring(0, 240) }
        $ni.ShowBalloonTip(4000, $Title, $tipBody, [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Milliseconds 600
        $ni.Visible = $false
        $ni.Dispose()
        return
    }
    catch {
        Write-WatchLog 'WARN' "Toast failed; console-only fallback. err=$($_.Exception.Message)"
    }
}

function Emit-HandoffNotice {
    param(
        [string]$Path,
        [string]$Type,
        [string]$TaskId,
        [string]$Round
    )
    $hint = Get-Hint -Type $Type
    Write-Host ''
    Write-Host "[handoff] type=$Type"
    Write-Host " path=$Path"
    Write-Host " task_id=$TaskId round=$Round"
    Write-Host " hint=$hint"
    Write-Host ''

    # Optional desktop tip; never interrupts console notify / main loop
    try {
        Show-WatcherToast -Title ("handoff " + $Type) -Body ("task_id=$TaskId round=$Round`n$hint`n$Path")
    }
    catch {
        Write-WatchLog 'WARN' "Toast wrapper failed; console-only fallback. err=$($_.Exception.Message)"
    }
}

function Test-ProcessAlive {
    param([int]$ProcessId)
    if ($ProcessId -le 0) { return $false }
    try {
        $p = Get-Process -Id $ProcessId -ErrorAction Stop
        return ($null -ne $p)
    }
    catch {
        return $false
    }
}

function Read-LockInfo {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    try {
        $raw = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
        return ($raw | ConvertFrom-Json)
    }
    catch {
        return $null
    }
}

function Enter-WatcherLock {
    param(
        [string]$Path,
        [switch]$Force
    )

    $myPid = $PID
    $payload = [ordered]@{
        pid       = $myPid
        startedAt = (Get-Date).ToString('o')
        watchDir  = $WatchDir
        host      = $env:COMPUTERNAME
    }

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $info = Read-LockInfo -Path $Path
        $otherPid = 0
        if ($null -ne $info -and $null -ne $info.pid) {
            $otherPid = [int]$info.pid
        }

        if ($otherPid -eq $myPid) {
            $script:LockAcquired = $true
            return
        }

        if ((-not $Force) -and (Test-ProcessAlive -ProcessId $otherPid)) {
            throw "Another watcher holds the lock: pid=$otherPid file=$Path (use -ForceUnlock only if stale)"
        }

        Write-WatchLog 'WARN' "Removing stale/force lock (pid=$otherPid): $Path"
        Remove-Item -LiteralPath $Path -Force -ErrorAction Stop
    }

    # Create new lock; fail if raced.
    $json = ($payload | ConvertTo-Json -Compress)
    try {
        $fs = [System.IO.File]::Open($Path, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
        try {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
            $fs.Write($bytes, 0, $bytes.Length)
        }
        finally {
            $fs.Dispose()
        }
    }
    catch [System.IO.IOException] {
        throw "Failed to acquire lock (another instance won the race?): $Path"
    }

    $script:LockAcquired = $true
    Write-WatchLog 'INFO' "Lock acquired pid=$myPid file=$Path"
}

function Exit-WatcherLock {
    if (-not $script:LockAcquired) { return }
    if (-not (Test-Path -LiteralPath $script:LockFilePath -PathType Leaf)) {
        $script:LockAcquired = $false
        return
    }
    $info = Read-LockInfo -Path $script:LockFilePath
    if ($null -ne $info -and [int]$info.pid -eq $PID) {
        Remove-Item -LiteralPath $script:LockFilePath -Force -ErrorAction SilentlyContinue
        Write-WatchLog 'INFO' "Lock released: $($script:LockFilePath)"
    }
    $script:LockAcquired = $false
}

function Import-WatcherState {
    param([string]$Path)
    $script:Notified = @{}
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Write-WatchLog 'INFO' "No state file yet: $Path"
        return
    }
    try {
        $obj = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($null -ne $obj.notified) {
            foreach ($p in $obj.notified.PSObject.Properties) {
                $script:Notified[$p.Name] = $true
            }
        }
        Write-WatchLog 'INFO' ("Loaded state entries={0} file={1}" -f $script:Notified.Count, $Path)
    }
    catch {
        Write-WatchLog 'WARN' "State unreadable; starting empty. file=$Path err=$($_.Exception.Message)"
        $script:Notified = @{}
    }
}

function Save-WatcherState {
    param([string]$Path)
    $map = [ordered]@{}
    foreach ($k in ($script:Notified.Keys | Sort-Object)) {
        $map[$k] = $true
    }
    $doc = [ordered]@{
        version   = 1
        updatedAt = (Get-Date).ToString('o')
        watchDir  = $WatchDir
        notified  = $map
    }
    $json = $doc | ConvertTo-Json -Depth 5
    $tmp = "$Path.tmp"
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($tmp, $json, $utf8NoBom)
    Move-Item -LiteralPath $tmp -Destination $Path -Force
}

Enter-WatcherLock -Path $LockFile -Force:$ForceUnlock
Import-WatcherState -Path $StateFile

Write-WatchLog 'INFO' "Watcher R3 started. watch=$WatchDir poll=${PollSeconds}s debounce=${DebounceSeconds}s requireHeading=$RequireHeading toast=$Toast"
Write-WatchLog 'INFO' "state=$StateFile lock=$LockFile"
Write-WatchLog 'INFO' 'Notify only. No execute / no git / no network. Ctrl+C to stop.'

$started = Get-Date
try {
    while ($true) {
        if ($DurationSeconds -gt 0) {
            $elapsed = ((Get-Date) - $started).TotalSeconds
            if ($elapsed -ge $DurationSeconds) {
                Write-WatchLog 'INFO' "DurationSeconds=$DurationSeconds reached; exiting."
                break
            }
        }

        $files = @(Get-ChildItem -LiteralPath $WatchDir -File -ErrorAction Stop)
        $seen = @{}
        $stateDirty = $false

        foreach ($f in $files) {
            $name = $f.Name
            if (Test-IgnoredName -Name $name) { continue }

            $type = Get-HandoffType -Name $name
            if (-not $type) { continue }

            $full = $f.FullName
            $seen[$full] = $true
            $size = [long]$f.Length
            $mtime = $f.LastWriteTimeUtc

            if (-not $script:Pending.ContainsKey($full)) {
                $script:Pending[$full] = @{
                    Size           = $size
                    MtimeUtc       = $mtime
                    StableSinceUtc = [datetime]::UtcNow
                }
                continue
            }

            $prev = $script:Pending[$full]
            if ($prev.Size -ne $size -or $prev.MtimeUtc -ne $mtime) {
                $script:Pending[$full] = @{
                    Size           = $size
                    MtimeUtc       = $mtime
                    StableSinceUtc = [datetime]::UtcNow
                }
                continue
            }

            $stableFor = ([datetime]::UtcNow - [datetime]$prev.StableSinceUtc).TotalSeconds
            if ($stableFor -lt $DebounceSeconds) { continue }

            $key = Get-NotifyKey -Path $full -Size $size -MtimeUtc $mtime
            if ($script:Notified.ContainsKey($key)) { continue }

            if (-not (Test-ExpectedHeading -Path $full -Type $type)) {
                Write-WatchLog 'DEBUG' "Stable but missing expected heading: $name"
                $script:Notified[$key] = $true
                $stateDirty = $true
                continue
            }

            $meta = Get-TaskMeta -Name $name
            Emit-HandoffNotice -Path $full -Type $type -TaskId $meta.TaskId -Round $meta.Round
            $script:Notified[$key] = $true
            $stateDirty = $true
        }

        if ($stateDirty) {
            Save-WatcherState -Path $StateFile
        }

        foreach ($pkey in @($script:Pending.Keys)) {
            if (-not $seen.ContainsKey($pkey)) {
                $script:Pending.Remove($pkey)
            }
        }

        Start-Sleep -Seconds $PollSeconds
    }
}
finally {
    try { Exit-WatcherLock } catch { Write-WatchLog 'WARN' "Lock release failed: $($_.Exception.Message)" }
    Write-WatchLog 'INFO' 'Watcher R3 stopped.'
}