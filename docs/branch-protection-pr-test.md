# Branch Protection PR Test

This document records the first pull request used to verify the `main` branch protection rule.

## Purpose

Confirm that the repository now follows the expected flow:

1. Work starts on a non-`main` branch.
2. The branch is pushed to GitHub.
3. A pull request targets `main`.
4. `Docs validation` runs before merge.

## Expected Result

- Direct local commits to `main` are no longer the normal path.
- `Docs validation` is visible on the pull request.
- High-risk task `T004` remains `待确认`.

## Scope

This is a low-risk documentation-only test. It does not change workflow policy, code, CI logic, or high-risk approval rules.
