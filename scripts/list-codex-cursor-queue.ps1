<#
.SYNOPSIS
  Read-only handoff queue: list *-result.md for Codex judgement review (R1).

.DESCRIPTION
  Scans docs/handoffs/codex-cursor for *-result.md, prints Markdown table or JSON.
  Does not modify files, call APIs, commit, or push.
  Spec: docs/handoffs/codex-cursor/READONLY_QUEUE_SCRIPT.md

.PARAMETER HandoffDir
  Directory to scan (default: <repo>/docs/handoffs/codex-cursor).

.PARAMETER Json
  Emit JSON array instead of Markdown table.
#>
param(
    [string]$HandoffDir = '',
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($HandoffDir)) {
    $HandoffDir = Join-Path $PSScriptRoot '..\docs\handoffs\codex-cursor'
}
$HandoffDir = [System.IO.Path]::GetFullPath($HandoffDir)
if (-not (Test-Path -LiteralPath $HandoffDir -PathType Container)) {
    throw "Handoff directory not found: $HandoffDir"
}

$ignoreExact = @(
    'README.md', 'INDEX.md', 'STATE.md', 'QUEUE.md', 'RISK_GATE.md',
    'CROSS_REPO_OBSERVER.md', 'CURSOR_RECEIVE.md', 'CODEX_JUDGEMENT_SEMI_AUTO.md',
    'PROCESS_BRIDGE_EVAL.md', 'READONLY_QUEUE_SCRIPT.md', 'AUTOMATION_STEPS_CLOSEOUT.md'
)

$highRiskKeywords = @(
    '权限', '支付', '数据库', '迁移', '用户数据', '鉴权', '安全', '生产', '发布',
    '小红书', '抓取', '账号', 'F4', '日更',
    'permission', 'payment', 'database', 'migration', 'auth', 'production', 'publish'
)

function Test-IgnoredName {
    param([string]$Name)
    if ($Name -like '_template-*') { return $true }
    if ($ignoreExact -contains $Name) { return $true }
    if ($Name -notlike '*-result.md') { return $true }
    return $false
}

function Get-MetaFromFileName {
    param([string]$Name)
    if ($Name -match '^(?<id>.+)-r(?<round>\d{2})-result\.md$') {
        return @{ TaskId = $Matches['id']; Round = $Matches['round'] }
    }
    return @{ TaskId = '?'; Round = '??' }
}

function Get-FieldFromText {
    param(
        [string]$Text,
        [string]$Field
    )
    # - field: value  (YAML-ish in CURSOR_RESULT)
    $pat = '(?m)^\s*-\s*' + [regex]::Escape($Field) + '\s*:\s*(.+?)\s*$'
    $m = [regex]::Match($Text, $pat)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

function Get-RiskHint {
    param([string]$Text)
    foreach ($kw in $highRiskKeywords) {
        if ($Text -match [regex]::Escape($kw)) {
            return 'high'
        }
    }
    return 'low'
}

function Get-SuggestedJudgement {
    param(
        [string]$Status,
        [string]$RiskHint
    )
    $s = if ($null -eq $Status) { '' } else { $Status.Trim().ToLowerInvariant() }
    if ($RiskHint -eq 'high') { return 'need_confirm' }
    if ($s -eq 'blocked' -or $s -eq 'need_confirm') { return 'blocked' }
    if ($s -eq 'done') { return 'pass_review' }
    return 'review'
}

function Get-SortRank {
    param([string]$Suggested)
    switch ($Suggested) {
        'need_confirm' { return 0 }
        'blocked' { return 1 }
        'pass_review' { return 2 }
        default { return 3 }
    }
}

$rows = New-Object System.Collections.Generic.List[object]

$files = @(Get-ChildItem -LiteralPath $HandoffDir -File -ErrorAction Stop)
foreach ($f in $files) {
    if (Test-IgnoredName -Name $f.Name) { continue }

    $text = ''
    try {
        $text = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 -ErrorAction Stop
    }
    catch {
        $text = ''
    }

    $meta = Get-MetaFromFileName -Name $f.Name
    $taskId = Get-FieldFromText -Text $text -Field 'task_id'
    $round = Get-FieldFromText -Text $text -Field 'round'
    $status = Get-FieldFromText -Text $text -Field 'status'
    $modeDone = Get-FieldFromText -Text $text -Field 'mode_done'

    if ([string]::IsNullOrWhiteSpace($taskId)) { $taskId = $meta.TaskId }
    if ([string]::IsNullOrWhiteSpace($round)) { $round = $meta.Round }
    if ([string]::IsNullOrWhiteSpace($status)) { $status = '?' }
    if ([string]::IsNullOrWhiteSpace($modeDone)) { $modeDone = '?' }

    $riskHint = Get-RiskHint -Text $text
    $suggested = Get-SuggestedJudgement -Status $status -RiskHint $riskHint
    $rel = $f.Name

    $rows.Add([pscustomobject]@{
            task_id              = $taskId
            round                = $round
            result_path          = $rel
            status               = $status
            mode_done            = $modeDone
            risk_hint            = $riskHint
            mtime                = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
            mtime_ticks          = $f.LastWriteTimeUtc.Ticks
            suggested_judgement  = $suggested
            sort_rank            = (Get-SortRank -Suggested $suggested)
        }) | Out-Null
}

$sorted = @($rows | Sort-Object sort_rank, @{ Expression = 'mtime_ticks'; Descending = $true }, task_id)

if ($Json) {
    $payload = @(
        foreach ($r in $sorted) {
            [ordered]@{
                task_id             = $r.task_id
                round               = $r.round
                result_path         = $r.result_path
                status              = $r.status
                mode_done           = $r.mode_done
                risk_hint           = $r.risk_hint
                mtime               = $r.mtime
                suggested_judgement = $r.suggested_judgement
            }
        }
    )
    $payload | ConvertTo-Json -Depth 4
    exit 0
}

Write-Output '| task_id | round | result_path | status | mode_done | risk_hint | mtime | suggested_judgement |'
Write-Output '|---------|-------|-------------|--------|-----------|-----------|-------|---------------------|'
if ($sorted.Count -eq 0) {
    Write-Output '| (none) | | | | | | | |'
}
else {
    foreach ($r in $sorted) {
        $line = '| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7} |' -f `
            $r.task_id, $r.round, $r.result_path, $r.status, $r.mode_done, `
            $r.risk_hint, $r.mtime, $r.suggested_judgement
        Write-Output $line
    }
}
Write-Output ''
Write-Output ("<!-- readonly queue count={0} dir={1} -->" -f $sorted.Count, $HandoffDir)