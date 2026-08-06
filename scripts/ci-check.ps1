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

$markdownFiles = Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '\\.git\\' }

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

    $pendingConfirmation = -join ([char[]](0x5F85, 0x786E, 0x8BA4))
    if (($backlog -match 'T004') -and ($backlog -notmatch "T004.*$pendingConfirmation")) {
        Add-Failure 'High-risk sample T004 must remain pending confirmation in tasks/backlog.md'
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
