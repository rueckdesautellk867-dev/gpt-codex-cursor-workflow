param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

if (-not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
    throw "Target path does not exist or is not a directory: $TargetPath"
}

$targetRoot = (Resolve-Path -LiteralPath $TargetPath).Path

$files = @(
    'AGENTS.md',
    'PR_CHECKLIST.md',
    '.cursor/rules/ai-workflow.mdc',
    '.github/workflows/ci.yml',
    'scripts/ci-check.ps1',
    'docs/ai-task-routing.md',
    'docs/ai-workflow.md',
    'docs/ci.md',
    'docs/definition-of-done.md',
    'docs/risk-approval.md',
    'docs/runbook.md',
    'docs/task-template.md',
    'docs/verification.md',
    'tasks/README.md'
)

$copied = New-Object System.Collections.Generic.List[string]
$skipped = New-Object System.Collections.Generic.List[string]
$created = New-Object System.Collections.Generic.List[string]

foreach ($relativePath in $files) {
    $source = Join-Path $sourceRoot $relativePath
    $target = Join-Path $targetRoot $relativePath

    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Template source file is missing: $relativePath"
    }

    if ((Test-Path -LiteralPath $target) -and -not $Force) {
        $skipped.Add($relativePath) | Out-Null
        continue
    }

    $targetDir = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $targetDir -PathType Container)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    Copy-Item -LiteralPath $source -Destination $target -Force:$Force
    $copied.Add($relativePath) | Out-Null
}

function Write-StarterFile {
    param(
        [string]$RelativePath,
        [string]$Content
    )

    $target = Join-Path $targetRoot $RelativePath
    if ((Test-Path -LiteralPath $target) -and -not $Force) {
        $skipped.Add($RelativePath) | Out-Null
        return
    }

    $targetDir = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $targetDir -PathType Container)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    Set-Content -LiteralPath $target -Encoding UTF8 -Value $Content
    $created.Add($RelativePath) | Out-Null
}

Write-StarterFile 'README.md' @'
# Project With GPT + Codex + Cursor Workflow

This project uses the GPT + Codex + Cursor workflow template.

## Workflow Entry

- `AGENTS.md`
- `.cursor/rules/ai-workflow.mdc`
- `PR_CHECKLIST.md`
- `docs/runbook.md`
- `tasks/backlog.md`

## First Step

Create the first low-risk task from `docs/task-template.md`, register it in `tasks/backlog.md`, and run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ci-check.ps1
```
'@

Write-StarterFile 'docs/project-status.md' @'
# Project Status

| Item | Value |
|------|-------|
| Project name | TODO |
| Current version | Template installed |
| Current workspace | TODO |
| Remote repository | TODO |

## Current Capabilities

- Workflow rules copied
- Task template copied
- Verification standard copied
- Risk approval process copied
- CI script copied

## Next Steps

1. Customize this status file.
2. Create the first low-risk task.
3. Run local CI.
4. Decide whether to configure GitHub Actions and branch protection.
'@

Write-StarterFile 'docs/pilot-log.md' @'
# Pilot Log

Record the first three workflow trials here.

## Trial 1

- Goal:
- Result:
- Verification:
- Risk:
'@

Write-StarterFile 'tasks/backlog.md' @'
# Task Backlog

Status values: `待办` / `进行中` / `待确认` / `已完成` / `已取消`

Usage: see [tasks/README.md](README.md).

| ID | Title | Risk | Owner | Status | Task File |
|----|-------|------|-------|--------|-----------|

## Notes

- Add the first project-specific task before implementation.
- High-risk tasks must start as `待确认`.
'@

Write-Host "Template rollout complete."
Write-Host "Target: $targetRoot"
Write-Host "Copied: $($copied.Count)"
foreach ($item in $copied) {
    Write-Host "- copied: $item"
}

if ($created.Count -gt 0) {
    Write-Host "Starter files created: $($created.Count)"
    foreach ($item in $created) {
        Write-Host "- created: $item"
    }
}

if ($skipped.Count -gt 0) {
    Write-Host "Skipped existing files: $($skipped.Count)"
    foreach ($item in $skipped) {
        Write-Host "- skipped: $item"
    }
    Write-Host "Use -Force to overwrite existing files."
}
