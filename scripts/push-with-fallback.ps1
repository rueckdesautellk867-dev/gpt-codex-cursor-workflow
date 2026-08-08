# Push with short retries; on failure record local tip and pending Desktop marker.
# Does not hang forever on github.com:443 failures.
# Writes .pending-desktop-push.json (gitignored) when push fails.
param(
  [switch]$StatusOnly,
  [switch]$ProbeOnly,
  [ValidateRange(1, 5)]
  [int]$MaxAttempts = 2,
  [string]$RepoPath = ""
)

$ErrorActionPreference = "Continue"

if (-not $RepoPath) {
  $RepoPath = Split-Path -Parent $PSScriptRoot
}
$RepoPath = (Resolve-Path $RepoPath).Path
$MarkerPath = Join-Path $RepoPath ".pending-desktop-push.json"

function Write-Marker {
  param(
    [string]$LocalTip,
    [string]$Subject,
    [string]$Branch,
    [string]$RemoteTracking,
    [string]$LastError
  )
  $shortLen = [Math]::Min(7, $LocalTip.Length)
  $payload = [ordered]@{
    status          = "pending_desktop_push"
    repo            = $RepoPath
    branch          = $Branch
    local_tip       = $LocalTip
    local_tip_short = $LocalTip.Substring(0, $shortLen)
    subject         = $Subject
    remote_tracking = $RemoteTracking
    failed_at       = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")
    last_error      = $LastError
    action          = "Open GitHub Desktop and Push origin, or say: agree-push-workflow-repo"
  }
  ($payload | ConvertTo-Json -Depth 5) | Set-Content -Path $MarkerPath -Encoding UTF8
}

function Clear-Marker {
  if (Test-Path $MarkerPath) {
    Remove-Item -Force $MarkerPath
    Write-Host ("Cleared pending marker: " + $MarkerPath)
  }
}

function Show-Status {
  Write-Host ("repo: " + $RepoPath)
  & git -C $RepoPath status --short --branch | ForEach-Object { Write-Host $_ }
  $tip = (& git -C $RepoPath rev-parse HEAD 2>$null)
  $msg = (& git -C $RepoPath log -1 --pretty=%s 2>$null)
  Write-Host ("HEAD: " + $tip)
  Write-Host ("subject: " + $msg)
  if (Test-Path $MarkerPath) {
    Write-Host "PENDING_DESKTOP_PUSH=yes"
    Get-Content $MarkerPath -Raw
    return 2
  }
  Write-Host "PENDING_DESKTOP_PUSH=no"
  return 0
}

if ($StatusOnly) {
  exit (Show-Status)
}

# HTTPS curl to github.com is informative only. Origin may be SSH-over-443
# (ssh://git@ssh.github.com:443/...), where ls-remote is the real readiness signal.
Write-Host "==== probe curl github.com (informational) ===="
$curlOut = & curl.exe -sI --connect-timeout 12 --max-time 20 https://github.com 2>&1
$curlCode = $LASTEXITCODE
$curlOut | Select-Object -First 6 | ForEach-Object { Write-Host $_ }
Write-Host ("curl_exit=" + $curlCode)

Write-Host "==== probe git ls-remote (authoritative) ===="
$lsOut = & git -C $RepoPath ls-remote --heads origin 2>&1
$lsCode = $LASTEXITCODE
$lsOut | Select-Object -First 5 | ForEach-Object { Write-Host $_ }
Write-Host ("ls_remote_exit=" + $lsCode)

if ($ProbeOnly) {
  if ($lsCode -eq 0) {
    $head = (& git -C $RepoPath rev-parse HEAD).Trim()
    $origin = (& git -C $RepoPath rev-parse origin/main 2>$null)
    if ($origin -and ($head -eq $origin.Trim())) {
      Clear-Marker
    }
    Write-Host "PROBE_OK"
    exit 0
  }
  Write-Host "PROBE_FAIL"
  exit 1
}

$branch = (& git -C $RepoPath rev-parse --abbrev-ref HEAD).Trim()
$localTip = (& git -C $RepoPath rev-parse HEAD).Trim()
$subject = (& git -C $RepoPath log -1 --pretty=%s).Trim()
$remoteTracking = (& git -C $RepoPath rev-parse "@{u}" 2>$null)
if (-not $remoteTracking) {
  $remoteTracking = (& git -C $RepoPath rev-parse ("origin/" + $branch) 2>$null)
}
if (-not $remoteTracking) {
  $remoteTracking = ""
} else {
  $remoteTracking = $remoteTracking.Trim()
}

# Never treat "not ahead of local tracking" as proven remote sync when ls-remote fails.
# Local origin/* can lag or be stale; only clear marker after a successful ls-remote
# that shows the same tip (or a successful push). HTTPS curl failure alone must not block
# SSH-over-443 remotes.
if ($lsCode -ne 0) {
  $probeErr = "probe failed ls_remote_exit=$lsCode curl_exit=$curlCode"
  Write-Host ("PROBE_BLOCK: " + $probeErr + " — will not clear pending marker / will not claim synced.")
  Write-Marker -LocalTip $localTip -Subject $subject -Branch $branch `
    -RemoteTracking $remoteTracking -LastError $probeErr
  Write-Host ("CLI cannot reach origin reliably. Recorded local tip=" + $localTip.Substring(0, 7) + " " + $subject)
  Write-Host "Status: pending Desktop push. When network is OK, say: agree push workflow repo"
  Write-Host ("Marker: " + $MarkerPath)
  exit 1
}
if ($curlCode -ne 0) {
  Write-Host ("NOTE: https://github.com curl failed (exit=$curlCode); continuing because ls-remote succeeded (SSH/git path OK).")
}

$remoteTipFromLs = ""
foreach ($line in @($lsOut)) {
  $text = [string]$line
  if ($text -match "^([0-9a-f]{40})\s+refs/heads/$([regex]::Escape($branch))\s*$") {
    $remoteTipFromLs = $Matches[1]
    break
  }
}

$statusLine = (& git -C $RepoPath status --short --branch | Select-Object -First 1)
if ($statusLine -notmatch "ahead") {
  if ($remoteTipFromLs -and ($remoteTipFromLs -eq $localTip)) {
    Write-Host ("Nothing to push (remote tip already matches HEAD " + $localTip.Substring(0, 7) + ").")
    Clear-Marker
    exit 0
  }
  Write-Host "Local tracking not ahead, but remote tip unproven/mismatch — attempting push to verify auth+sync."
}

$lastError = ""
$ok = $false
for ($i = 1; $i -le $MaxAttempts; $i++) {
  Write-Host ("==== push attempt " + $i + "/" + $MaxAttempts + " ====")
  $pushOut = & git -C $RepoPath push origin HEAD 2>&1
  $pushCode = $LASTEXITCODE
  $pushOut | ForEach-Object { Write-Host $_ }
  if ($pushCode -eq 0) {
    $ok = $true
    break
  }
  $lastError = (($pushOut | Out-String).Trim() -replace "\s+", " ")
  if ($lastError.Length -gt 240) {
    $lastError = $lastError.Substring(0, 240)
  }
  Start-Sleep -Seconds 2
}

if ($ok) {
  Clear-Marker
  Write-Host ("PUSH_OK tip=" + $localTip.Substring(0, 7))
  exit 0
}

Write-Marker -LocalTip $localTip -Subject $subject -Branch $branch `
  -RemoteTracking $remoteTracking -LastError $lastError
$short = $localTip.Substring(0, 7)
Write-Host ""
Write-Host ("CLI push failed. Recorded local tip=" + $short + " " + $subject)
Write-Host "Status: pending Desktop push. When network is OK, say: agree push workflow repo"
Write-Host ("Marker: " + $MarkerPath)
exit 1
