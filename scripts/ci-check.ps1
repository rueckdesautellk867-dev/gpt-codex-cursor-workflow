param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $failures.Add($Message) | Out-Null
}

function Test-RequiredFile {
    param([string]$RelativePath)

    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Add-Failure "Missing required file: $RelativePath"
    }
}

function Get-DisplayPath {
    param([string]$Path)

    $rootPath = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\') + '\'
    $rootUri = New-Object System.Uri($rootPath)
    $pathUri = New-Object System.Uri($Path)
    return [System.Uri]::UnescapeDataString($rootUri.MakeRelativeUri($pathUri).ToString()).Replace('/', '\')
}

$requiredFiles = @(
    'README.md',
    'AGENTS.md',
    'PR_CHECKLIST.md',
    'docs/definition-of-done.md',
    'docs/verification.md',
    'docs/risk-approval.md',
    'docs/runbook.md',
    'docs/project-status.md',
    'tasks/README.md',
    'tasks/backlog.md'
)

foreach ($file in $requiredFiles) {
    Test-RequiredFile $file
}

$scanRoots = @(
    'README.md',
    'AGENTS.md',
    'PR_CHECKLIST.md',
    'docs',
    'tasks'
)

$markdownFiles = @()
foreach ($scanRoot in $scanRoots) {
    $scanPath = Join-Path $Root $scanRoot
    if (-not (Test-Path -LiteralPath $scanPath)) {
        continue
    }

    if (Test-Path -LiteralPath $scanPath -PathType Leaf) {
        if ([System.IO.Path]::GetExtension($scanPath) -eq '.md') {
            $markdownFiles += Get-Item -LiteralPath $scanPath
        }
        continue
    }

    $markdownFiles += Get-ChildItem -LiteralPath $scanPath -Recurse -File -Filter '*.md' |
        Where-Object { $_.FullName -notmatch '\\.git\\' }
}

foreach ($file in $markdownFiles) {
    $relativeFile = Get-DisplayPath $file.FullName
    $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8

    if ($content -match '`r`n') {
        Add-Failure "Literal newline escape found in markdown: $relativeFile"
    }

    $matches = [regex]::Matches($content, '\[[^\]]+\]\(([^)]+)\)')
    foreach ($match in $matches) {
        $target = $match.Groups[1].Value.Trim()

        if ([string]::IsNullOrWhiteSpace($target)) {
            Add-Failure "Empty markdown link target in $relativeFile"
            continue
        }

        if ($target -match '^(https?:|mailto:|#)') {
            continue
        }

        $pathPart = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) {
            continue
        }

        $pathPart = $pathPart -replace '/', [System.IO.Path]::DirectorySeparatorChar
        $baseDir = Split-Path -Parent $file.FullName

        if ([System.IO.Path]::IsPathRooted($pathPart)) {
            $candidate = $pathPart
        } else {
            $candidate = Join-Path $baseDir $pathPart
        }

        if (-not (Test-Path -LiteralPath $candidate)) {
            Add-Failure "Broken markdown link in ${relativeFile}: $target"
        }
    }
}

$backlogPath = Join-Path $Root 'tasks/backlog.md'
if (Test-Path -LiteralPath $backlogPath -PathType Leaf) {
    $backlog = Get-Content -LiteralPath $backlogPath -Raw -Encoding UTF8
    $taskFiles = Get-ChildItem -LiteralPath (Join-Path $Root 'tasks') -File -Filter 'T*.md' |
        Sort-Object Name

    foreach ($taskFile in $taskFiles) {
        if ($backlog -notmatch [regex]::Escape($taskFile.Name)) {
            Add-Failure "Task file is not referenced from tasks/backlog.md: $($taskFile.Name)"
        }
    }

    $taskLinks = [regex]::Matches($backlog, '\((T\d{3}[^)]*\.md)\)')
    foreach ($taskLink in $taskLinks) {
        $taskPath = Join-Path (Join-Path $Root 'tasks') $taskLink.Groups[1].Value
        if (-not (Test-Path -LiteralPath $taskPath -PathType Leaf)) {
            Add-Failure "Backlog references missing task file: $($taskLink.Groups[1].Value)"
        }
    }

    if ($backlog -match 'T004-high-risk') {
        $pendingConfirmation = -join ([char[]](0x5F85, 0x786E, 0x8BA4))
        if ($backlog -notmatch "T004.*$pendingConfirmation") {
            Add-Failure 'High-risk sample T004 must remain pending confirmation in tasks/backlog.md'
        }
    }

    # ---- High-risk manual-approval gate (Phase 3, 2026-08-21) ----
    # Rule: a high-risk task (风险=高) may only be marked 已完成 if its task file
    # contains a '## 人工审批记录' section with a filled 审批人.
    # Historical baseline: tasks with numeric id <= $HighRiskGateBaseline were completed
    # before this gate existed and are exempt; new high-risk tasks (id > baseline) are enforced.
    $HighRiskGateBaseline = 335
    $riskRows = [regex]::Matches($backlog, '\|\s*(T(\d{3})[^\|]*?)\s*\|\s*([^|]+?)\s*\|\s*[^|]+?\s*\|\s*([^|]+?)\s*\|')
    foreach ($row in $riskRows) {
        $idNum = [int]$row.Groups[2].Value
        $risk = $row.Groups[3].Value.Trim()
        $status = $row.Groups[4].Value.Trim()
        if ($idNum -gt $HighRiskGateBaseline -and $risk -match '高' -and $status -match '已完成') {
            $idStr = $row.Groups[1].Value
            $matchFile = $taskFiles | Where-Object { $_.BaseName -match ("^" + [regex]::Escape($idStr) + '(-|$)') } | Select-Object -First 1
            if (-not $matchFile) {
                Add-Failure "High-risk task $idStr is 已完成 but has no task file with an approval record."
                continue
            }
            $taskContent = Get-Content -LiteralPath $matchFile.FullName -Raw -Encoding UTF8
            if ($taskContent -notmatch '人工审批记录') {
                Add-Failure "High-risk task $($matchFile.Name) is 已完成 but missing '## 人工审批记录'; manual approval required before completion."
            } elseif ($taskContent -notmatch '审批人[：:]\s*\S') {
                Add-Failure "High-risk task $($matchFile.Name) approval record is missing a filled 审批人."
            }
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host 'CI checks failed:'
    foreach ($failure in $failures) {
        Write-Host "- $failure"
    }
    exit 1
}

Write-Host 'CI checks passed.'
Write-Host "- Required files: $($requiredFiles.Count)"
Write-Host "- Markdown files checked: $($markdownFiles.Count)"
