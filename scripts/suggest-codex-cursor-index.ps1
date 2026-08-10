<#
.SYNOPSIS
  Read-only INDEX update helper: suggest INDEX rows from handoff files (R1).

.DESCRIPTION
  Scans instruction/result files, compares to INDEX.md, prints suggestions and
  warnings. Never writes INDEX or any handoff file.
  Spec: docs/handoffs/codex-cursor/INDEX_UPDATE_HELPER.md

.PARAMETER HandoffDir
  Handoff directory (default: <repo>/docs/handoffs/codex-cursor).

.PARAMETER Json
  Emit JSON object with suggestions and warnings.
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

$indexPath = Join-Path $HandoffDir 'INDEX.md'
$statePath = Join-Path $HandoffDir 'STATE.md'
if (-not (Test-Path -LiteralPath $indexPath -PathType Leaf)) {
    throw "INDEX.md not found: $indexPath"
}
if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    throw "STATE.md not found: $statePath"
}

$ignoreExact = @(
    'README.md', 'INDEX.md', 'STATE.md', 'QUEUE.md', 'RISK_GATE.md',
    'CROSS_REPO_OBSERVER.md', 'CURSOR_RECEIVE.md', 'CODEX_JUDGEMENT_SEMI_AUTO.md',
    'PROCESS_BRIDGE_EVAL.md', 'READONLY_QUEUE_SCRIPT.md', 'INDEX_UPDATE_HELPER.md',
    'AUTOMATION_STEPS_CLOSEOUT.md'
)

$warnings = New-Object System.Collections.Generic.List[string]
$suggestions = New-Object System.Collections.Generic.List[object]

function Get-LegalStates {
    param([string]$StateText)
    $set = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($m in [regex]::Matches($StateText, '\|\s*`([a-z_]+)`\s*\|')) {
        [void]$set.Add($m.Groups[1].Value)
    }
    # ensure core enums even if parse fails partially
    foreach ($s in @('draft','ready_for_cursor','cursor_done','needs_codex_judgement','passed','needs_continue','blocked','committed','pushed')) {
        [void]$set.Add($s)
    }
    return $set
}

function Get-FieldFromText {
    param([string]$Text, [string]$Field)
    $pat = '(?m)^\s*-\s*' + [regex]::Escape($Field) + '\s*:\s*(.+?)\s*$'
    $m = [regex]::Match($Text, $pat)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

function Get-MetaFromName {
    param([string]$Name, [string]$Kind)
    if ($Kind -eq 'result') {
        if ($Name -match '^(?<id>.+)-r(?<round>\d{2})-result\.md$') {
            return @{ TaskId = $Matches['id']; Round = $Matches['round'] }
        }
    }
    else {
        if ($Name -match '^(?<id>.+)-r(?<round>\d{2})-instruction\.md$') {
            return @{ TaskId = $Matches['id']; Round = $Matches['round'] }
        }
    }
    return @{ TaskId = '?'; Round = '??' }
}

function Read-IndexRows {
    param([string]$Text)
    $rows = @{}
    $dupKeys = New-Object System.Collections.Generic.List[string]
    foreach ($line in ($Text -split "`r?`n")) {
        if ($line -notmatch '^\|') { continue }
        if ($line -match '^\|\s*[-:| ]+\|$') { continue }
        if ($line -match 'task_id') { continue }
        $parts = @($line.Trim('|').Split('|') | ForEach-Object { $_.Trim() })
        if ($parts.Count -lt 4) { continue }
        $tid = $parts[0]
        $round = $parts[1]
        $status = $parts[2]
        $resultCell = $parts[3]
        $commit = if ($parts.Count -gt 4) { $parts[4] } else { '-' }
        $push = if ($parts.Count -gt 5) { $parts[5] } else { 'no' }
        $note = if ($parts.Count -gt 6) { $parts[6] } else { '' }
        if ([string]::IsNullOrWhiteSpace($tid) -or $tid -eq 'task_id') { continue }
        $key = "$tid|$round"
        if ($rows.ContainsKey($key)) {
            $dupKeys.Add($key) | Out-Null
        }
        $resultFile = $resultCell
        if ($resultCell -match '\[([^\]]+)\]\(([^)]+)\)') {
            $resultFile = $Matches[2]
        }
        $rows[$key] = [pscustomobject]@{
            task_id = $tid
            round   = $round
            status  = $status
            result  = $resultFile
            commit  = $commit
            push    = $push
            note    = $note
        }
    }
    return @{ Rows = $rows; DupKeys = $dupKeys }
}

$stateText = Get-Content -LiteralPath $statePath -Raw -Encoding UTF8
$legal = Get-LegalStates -StateText $stateText
$indexText = Get-Content -LiteralPath $indexPath -Raw -Encoding UTF8
$indexInfo = Read-IndexRows -Text $indexText
$indexRows = $indexInfo.Rows
foreach ($dk in $indexInfo.DupKeys) {
    $warnings.Add("duplicate INDEX key: $dk") | Out-Null
}
foreach ($key in $indexRows.Keys) {
    $st = [string]$indexRows[$key].status
    if (-not $legal.Contains($st)) {
        $warnings.Add("illegal INDEX status for ${key}: '$st'") | Out-Null
    }
}

# Collect tasks from filesystem
$tasks = @{}  # key -> @{ instruction; result; ... }

$files = @(Get-ChildItem -LiteralPath $HandoffDir -File -ErrorAction Stop)
foreach ($f in $files) {
    $name = $f.Name
    if ($name -like '_template-*') { continue }
    if ($ignoreExact -contains $name) { continue }

    $kind = $null
    if ($name -like '*-instruction.md') { $kind = 'instruction' }
    elseif ($name -like '*-result.md') { $kind = 'result' }
    else { continue }

    $text = ''
    try { $text = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8 -ErrorAction Stop } catch { $text = '' }
    $meta = Get-MetaFromName -Name $name -Kind $kind
    $taskId = Get-FieldFromText -Text $text -Field 'task_id'
    $round = Get-FieldFromText -Text $text -Field 'round'
    $status = Get-FieldFromText -Text $text -Field 'status'
    $modeDone = Get-FieldFromText -Text $text -Field 'mode_done'
    if ([string]::IsNullOrWhiteSpace($taskId)) { $taskId = $meta.TaskId }
    if ([string]::IsNullOrWhiteSpace($round)) { $round = $meta.Round }

    $key = "$taskId|$round"
    if (-not $tasks.ContainsKey($key)) {
        $tasks[$key] = @{
            task_id     = $taskId
            round       = $round
            instruction = $null
            result      = $null
            result_status = $null
            mode_done   = $null
            parsed_statuses = New-Object System.Collections.Generic.List[string]
        }
    }
    $entry = $tasks[$key]
    if ($kind -eq 'instruction') {
        $entry.instruction = $name
    }
    else {
        $entry.result = $name
        $entry.result_status = $status
        $entry.mode_done = $modeDone
    }
    if (-not [string]::IsNullOrWhiteSpace($status)) {
        $entry.parsed_statuses.Add($status) | Out-Null
        if (-not $legal.Contains($status) -and $status -ne 'done' -and $status -ne 'need_confirm') {
            # done/need_confirm are CURSOR_RESULT values, not STATE — warn only if clearly unknown STATE-like token
            if ($status -match '^[a-z_]+$' -and $status -notin @('done','need_confirm','open')) {
                $warnings.Add("non-STATE status in ${name}: '$status' (suggestion will map conservatively)") | Out-Null
            }
        }
    }
    $tasks[$key] = $entry
}

foreach ($key in ($tasks.Keys | Sort-Object)) {
    $t = $tasks[$key]
    $inIndex = $indexRows.ContainsKey($key)
    $suggestedStatus = $null
    $action = $null
    $resultPath = if ($t.result) { $t.result } else { '-' }
    $note = 'suggestion only; do not auto-write INDEX'

    if ($t.result) {
        # Conservative: result present -> needs judgement unless INDEX already pushed/committed
        $suggestedStatus = 'needs_codex_judgement'
        if ($t.result_status -eq 'blocked' -or $t.result_status -eq 'need_confirm') {
            $suggestedStatus = 'blocked'
        }
        if ($inIndex) {
            $cur = [string]$indexRows[$key].status
            if ($cur -in @('pushed','committed','passed','needs_continue','blocked','needs_codex_judgement','cursor_done')) {
                if ($cur -eq $suggestedStatus) {
                    $action = 'unchanged'
                }
                elseif ($cur -in @('pushed','committed','passed') -and $suggestedStatus -eq 'needs_codex_judgement') {
                    # INDEX already further along; do not regress
                    $action = 'unchanged'
                    $suggestedStatus = $cur
                    $note = 'INDEX ahead of heuristic; keep INDEX status'
                }
                else {
                    $action = 'update_status'
                }
            }
            else {
                $action = 'update_status'
                if (-not $legal.Contains($cur)) {
                    $warnings.Add("INDEX has illegal status for ${key}: '$cur'; suggested='$suggestedStatus'") | Out-Null
                }
            }
        }
        else {
            $action = 'add'
        }
    }
    elseif ($t.instruction) {
        $suggestedStatus = 'ready_for_cursor'
        if ($inIndex) {
            $action = 'unchanged'
            $suggestedStatus = [string]$indexRows[$key].status
            $note = 'instruction only; INDEX exists — no auto change'
        }
        else {
            $action = 'add'
            $note = 'instruction without result; suggestion=ready_for_cursor'
        }
    }
    else {
        continue
    }

    if ($action -eq 'unchanged' -and $inIndex) {
        continue
    }

    $commit = '-'
    $push = 'no'
    if ($inIndex) {
        $commit = $indexRows[$key].commit
        $push = $indexRows[$key].push
    }

    if (-not $legal.Contains($suggestedStatus)) {
        $warnings.Add("suggested_status not in STATE enum for ${key}: '$suggestedStatus'") | Out-Null
    }

    $suggestions.Add([pscustomobject]@{
            action             = $action
            task_id            = $t.task_id
            round              = $t.round
            suggested_status   = $suggestedStatus
            result_path        = $resultPath
            commit             = $commit
            push               = $push
            note               = $note
            mode_done          = $(if ($t.mode_done) { $t.mode_done } else { '?' })
            parsed_result_status = $(if ($t.result_status) { $t.result_status } else { '?' })
        }) | Out-Null
}

# INDEX rows pointing to missing result files
foreach ($key in $indexRows.Keys) {
    $r = $indexRows[$key]
    $rf = [string]$r.result
    if ($rf -and $rf -ne '-' -and $rf -notmatch '^\s*$') {
        $path = Join-Path $HandoffDir $rf
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            $warnings.Add("INDEX result file missing for ${key}: $rf") | Out-Null
        }
    }
}

# Duplicate task_id across different rounds is OK; warn duplicate files same key already handled

if ($Json) {
    $sugArr = @(
        foreach ($s in $suggestions) {
            [pscustomobject]@{
                action               = [string]$s.action
                task_id              = [string]$s.task_id
                round                = [string]$s.round
                suggested_status     = [string]$s.suggested_status
                result_path          = [string]$s.result_path
                commit               = [string]$s.commit
                push                 = [string]$s.push
                note                 = [string]$s.note
                mode_done            = [string]$s.mode_done
                parsed_result_status = [string]$s.parsed_result_status
            }
        }
    )
    $warnArr = @($warnings | ForEach-Object { [string]$_ })
    $payload = [pscustomobject]@{
        handoff_dir      = [string]$HandoffDir
        suggestion_count = [int]$suggestions.Count
        warning_count    = [int]$warnings.Count
        suggestions      = $sugArr
        warnings         = $warnArr
    }
    $payload | ConvertTo-Json -Depth 6
    exit 0
}

Write-Output '# INDEX update suggestions (read-only; do not auto-apply)'
Write-Output ''
Write-Output '| action | task_id | round | suggested_status | result_path | commit | push | note |'
Write-Output '|--------|---------|-------|------------------|-------------|--------|------|------|'
if ($suggestions.Count -eq 0) {
    Write-Output '| (none) | | | | | | | |'
}
else {
    foreach ($s in $suggestions) {
        $line = '| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7} |' -f `
            $s.action, $s.task_id, $s.round, $s.suggested_status, $s.result_path, `
            $s.commit, $s.push, ($s.note -replace '\|', '/')
        Write-Output $line
    }
}

Write-Output ''
Write-Output '## warnings'
if ($warnings.Count -eq 0) {
    Write-Output '- (none)'
}
else {
    foreach ($w in $warnings) {
        Write-Output ("- {0}" -f $w)
    }
}
Write-Output ''
Write-Output ("<!-- suggest-index count={0} warnings={1} -->" -f $suggestions.Count, $warnings.Count)