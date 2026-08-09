<#
.SYNOPSIS
  Watcher R1: poll Codex↔Cursor handoff directory and print console notifications.

.DESCRIPTION
  Polls docs/handoffs/codex-cursor for stable *-instruction.md / *-result.md /
  *-judgement.md files. Console only. Does not execute instructions, call APIs,
  commit, push, or make network requests.

  Spec: docs/codex-cursor-watcher-mvp.md (R1)
  R2 (persistent state / single-instance lock) is out of scope.

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
#>
param(
    [string]$WatchDir = '',
    [double]$PollSeconds = 0.5,
    [double]$DebounceSeconds = 1.5,
    [int]$DurationSeconds = 0,
    [switch]$RequireHeading
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

# In-session dedupe only (R1). Restart may re-notify; R2 adds persistent state.
$script:Notified = @{}
# path -> @{ Size; MtimeUtc; StableSinceUtc }
$script:Pending = @{}

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
    return "$Path|$Size|$($MtimeUtc.Ticks)"
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
}

Write-WatchLog 'INFO' "Watcher R1 started. watch=$WatchDir poll=${PollSeconds}s debounce=${DebounceSeconds}s requireHeading=$RequireHeading"
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
                continue
            }

            $meta = Get-TaskMeta -Name $name
            Emit-HandoffNotice -Path $full -Type $type -TaskId $meta.TaskId -Round $meta.Round
            $script:Notified[$key] = $true
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
    Write-WatchLog 'INFO' 'Watcher R1 stopped.'
}