<#
.SYNOPSIS
  One-shot read-only Codex↔Cursor loop status aggregator (R1).

.DESCRIPTION
  Summarizes repo / watcher / queue / INDEX suggestions / next hints to stdout.
  Never writes files, never changes watcher state/lock or INDEX, never commits/pushes.
  Spec: docs/handoffs/codex-cursor/ONE_SHOT_OBSERVER.md

.PARAMETER RepoRoot
  Repository root (default: parent of this script's directory).

.PARAMETER Json
  Emit a single JSON object instead of Markdown.
#>
param(
    [string]$RepoRoot = '',
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-GitText {
    param(
        [string]$WorkDir,
        [string[]]$GitArgs
    )
    try {
        $prev = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        $out = & git -C $WorkDir @GitArgs 2>$null
        $ErrorActionPreference = $prev
        if ($LASTEXITCODE -ne 0) { return $null }
        if ($null -eq $out) { return '' }
        return (($out | ForEach-Object { [string]$_ }) -join "`n").Trim()
    }
    catch {
        return $null
    }
}

function Get-FileMeta {
    param(
        [string]$Path
    )
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return [ordered]@{
            exists = $false
            mtime  = $null
        }
    }
    $item = Get-Item -LiteralPath $Path -Force
    return [ordered]@{
        exists = $true
        mtime  = $item.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
    }
}

function Invoke-ChildJson {
    param(
        [string]$ScriptPath,
        [string]$HandoffDir
    )
    if (-not (Test-Path -LiteralPath $ScriptPath -PathType Leaf)) {
        throw "Child script not found: $ScriptPath"
    }
    $raw = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $ScriptPath -HandoffDir $HandoffDir -Json
    if ($LASTEXITCODE -ne 0) {
        throw "Child script failed ($LASTEXITCODE): $ScriptPath"
    }
    $text = if ($null -eq $raw) {
        ''
    }
    elseif ($raw -is [System.Array]) {
        ($raw | ForEach-Object { [string]$_ }) -join "`n"
    }
    else {
        [string]$raw
    }
    $text = $text.Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }
    return ($text | ConvertFrom-Json)
}

function Convert-ToObjectArray {
    param($Value)
    if ($null -eq $Value) { return @() }
    if ($Value -is [System.Array]) { return @($Value) }
    # ConvertFrom-Json may return a single PSCustomObject for one-element arrays
    return @($Value)
}

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Join-Path $PSScriptRoot '..'
}
$RepoRoot = [System.IO.Path]::GetFullPath($RepoRoot)
if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
    throw "RepoRoot not found: $RepoRoot"
}

$handoffDir = [System.IO.Path]::GetFullPath((Join-Path $RepoRoot 'docs\handoffs\codex-cursor'))
if (-not (Test-Path -LiteralPath $handoffDir -PathType Container)) {
    throw "Handoff directory not found: $handoffDir"
}

$queueScript = Join-Path $PSScriptRoot 'list-codex-cursor-queue.ps1'
$suggestScript = Join-Path $PSScriptRoot 'suggest-codex-cursor-index.ps1'

# --- repo ---
$branch = Get-GitText -WorkDir $RepoRoot -GitArgs @('rev-parse', '--abbrev-ref', 'HEAD')
$head = Get-GitText -WorkDir $RepoRoot -GitArgs @('rev-parse', '--short', 'HEAD')
$originMain = Get-GitText -WorkDir $RepoRoot -GitArgs @('rev-parse', '--short', 'origin/main')

$aheadBehind = $null
$abRaw = Get-GitText -WorkDir $RepoRoot -GitArgs @('rev-list', '--left-right', '--count', 'origin/main...HEAD')
if (-not [string]::IsNullOrWhiteSpace($abRaw)) {
    $parts = $abRaw -split '\s+'
    if ($parts.Count -ge 2) {
        $behind = [int]$parts[0]
        $ahead = [int]$parts[1]
        $aheadBehind = [ordered]@{
            ahead  = $ahead
            behind = $behind
            summary = ("ahead={0} behind={1}" -f $ahead, $behind)
        }
    }
}

$dirtyCount = 0
$statusPorcelain = Get-GitText -WorkDir $RepoRoot -GitArgs @('status', '--porcelain')
if (-not [string]::IsNullOrWhiteSpace($statusPorcelain)) {
    $dirtyCount = @($statusPorcelain -split "`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count
}

$repo = [ordered]@{
    repo_root     = $RepoRoot
    branch        = $(if ($null -eq $branch) { $null } else { $branch })
    head          = $(if ($null -eq $head) { $null } else { $head })
    origin_main   = $(if ($null -eq $originMain) { $null } else { $originMain })
    ahead_behind  = $aheadBehind
    dirty_count   = [int]$dirtyCount
}

# --- watcher (existence + mtime only; never read contents) ---
$lockPath = Join-Path $handoffDir '.watcher.lock'
$statePath = Join-Path $handoffDir '.watcher-state.json'
$lockMeta = Get-FileMeta -Path $lockPath
$stateMeta = Get-FileMeta -Path $statePath

$watcher = [ordered]@{
    handoff_dir           = $handoffDir
    watcher_lock_exists   = [bool]$lockMeta.exists
    watcher_lock_mtime    = $lockMeta.mtime
    watcher_state_exists  = [bool]$stateMeta.exists
    watcher_state_mtime   = $stateMeta.mtime
}

# --- queue ---
$queueParsed = Invoke-ChildJson -ScriptPath $queueScript -HandoffDir $handoffDir
$queueItems = Convert-ToObjectArray -Value $queueParsed

$needConfirm = 0
$blocked = 0
$passReview = 0
foreach ($q in $queueItems) {
    $sj = [string]$q.suggested_judgement
    switch ($sj) {
        'need_confirm' { $needConfirm++ }
        'blocked' { $blocked++ }
        'pass_review' { $passReview++ }
    }
}

$recentQueue = @(
    $queueItems | Select-Object -First 5 | ForEach-Object {
        [ordered]@{
            task_id             = [string]$_.task_id
            suggested_judgement = [string]$_.suggested_judgement
        }
    }
)

$queue = [ordered]@{
    total          = [int]$queueItems.Count
    need_confirm   = [int]$needConfirm
    blocked        = [int]$blocked
    pass_review    = [int]$passReview
    recent         = $recentQueue
}

# --- index suggestions ---
$suggestParsed = Invoke-ChildJson -ScriptPath $suggestScript -HandoffDir $handoffDir
$suggestionCount = 0
$warningCount = 0
$suggestionsList = @()
if ($null -ne $suggestParsed) {
    if ($null -ne $suggestParsed.suggestion_count) { $suggestionCount = [int]$suggestParsed.suggestion_count }
    if ($null -ne $suggestParsed.warning_count) { $warningCount = [int]$suggestParsed.warning_count }
    $suggestionsList = Convert-ToObjectArray -Value $suggestParsed.suggestions
    if ($suggestionCount -eq 0 -and $suggestionsList.Count -gt 0) {
        $suggestionCount = $suggestionsList.Count
    }
}

$recentSuggestions = @(
    $suggestionsList | Select-Object -First 5 | ForEach-Object {
        [ordered]@{
            task_id          = [string]$_.task_id
            action           = [string]$_.action
            suggested_status = [string]$_.suggested_status
        }
    }
)

$indexSuggestions = [ordered]@{
    suggestion_count = [int]$suggestionCount
    warning_count    = [int]$warningCount
    recent           = $recentSuggestions
}

# --- next hints ---
$hints = New-Object System.Collections.Generic.List[string]
if ($needConfirm -gt 0) {
    $hints.Add('need_confirm > 0: review RISK_GATE before judgement / INDEX write') | Out-Null
}
if ($queue.total -gt 0) {
    $hints.Add('queue has pending results: have Codex judge (pass / continue / stop)') | Out-Null
}
if ($suggestionCount -gt 0) {
    $hints.Add('INDEX suggestions exist: decide updates via SAFE_INDEX_APPLY (do not auto-write)') | Out-Null
}
if ($hints.Count -eq 0) {
    $hints.Add('No obvious pending queue/index items from this read-only snapshot') | Out-Null
}
$nextHints = @($hints)

$payload = [ordered]@{
    repo               = $repo
    watcher            = $watcher
    queue              = $queue
    index_suggestions  = $indexSuggestions
    next_hints         = $nextHints
    read_only          = $true
    note               = 'observer only; does not execute, judge, write INDEX, or commit/push'
}

if ($Json) {
    $payload | ConvertTo-Json -Depth 8
    exit 0
}

# --- Markdown ---
Write-Output '# Codex-Cursor Loop Status'
Write-Output ''
Write-Output '## Repo'
Write-Output ''
Write-Output ('- repo_root: `{0}`' -f $repo.repo_root)
Write-Output ('- branch: `{0}`' -f $(if ($null -eq $repo.branch) { 'n/a' } else { $repo.branch }))
Write-Output ('- HEAD: `{0}`' -f $(if ($null -eq $repo.head) { 'n/a' } else { $repo.head }))
Write-Output ('- origin/main: `{0}`' -f $(if ($null -eq $repo.origin_main) { 'n/a' } else { $repo.origin_main }))
if ($null -eq $repo.ahead_behind) {
    Write-Output '- ahead/behind: n/a'
}
else {
    Write-Output ('- ahead/behind: {0}' -f $repo.ahead_behind.summary)
}
Write-Output ('- dirty files: {0}' -f $repo.dirty_count)
Write-Output ''
Write-Output '## Watcher'
Write-Output ''
Write-Output ('- handoff_dir: `{0}`' -f $watcher.handoff_dir)
Write-Output ('- .watcher.lock: exists={0}; mtime={1}' -f $watcher.watcher_lock_exists, $(if ($null -eq $watcher.watcher_lock_mtime) { 'n/a' } else { $watcher.watcher_lock_mtime }))
Write-Output ('- .watcher-state.json: exists={0}; mtime={1}' -f $watcher.watcher_state_exists, $(if ($null -eq $watcher.watcher_state_mtime) { 'n/a' } else { $watcher.watcher_state_mtime }))
Write-Output '- note: existence/mtime only; lock/state contents not read; nothing modified'
Write-Output ''
Write-Output '## Queue'
Write-Output ''
Write-Output ('- total: {0}' -f $queue.total)
Write-Output ('- need_confirm: {0}' -f $queue.need_confirm)
Write-Output ('- blocked: {0}' -f $queue.blocked)
Write-Output ('- pass_review: {0}' -f $queue.pass_review)
Write-Output '- recent (up to 5):'
if ($queue.recent.Count -eq 0) {
    Write-Output '  - (none)'
}
else {
    foreach ($r in $queue.recent) {
        Write-Output ('  - `{0}` -> {1}' -f $r.task_id, $r.suggested_judgement)
    }
}
Write-Output ''
Write-Output '## Index Suggestions'
Write-Output ''
Write-Output ('- suggestion_count: {0}' -f $indexSuggestions.suggestion_count)
Write-Output ('- warning_count: {0}' -f $indexSuggestions.warning_count)
Write-Output '- recent (up to 5):'
if ($indexSuggestions.recent.Count -eq 0) {
    Write-Output '  - (none)'
}
else {
    foreach ($s in $indexSuggestions.recent) {
        Write-Output ('  - `{0}` | {1} | {2}' -f $s.task_id, $s.action, $s.suggested_status)
    }
}
Write-Output ''
Write-Output '## Next Hints'
Write-Output ''
foreach ($h in $nextHints) {
    Write-Output ('- {0}' -f $h)
}
Write-Output ''
Write-Output '<!-- show-codex-cursor-loop-status read-only -->'
