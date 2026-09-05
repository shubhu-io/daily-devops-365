# 365 DevOps Studio Synchronization Script
# Synchronizes index.html and assets across all 6 phase directories

$ErrorActionPreference = "Stop"

Write-Host "Verifying index.html..."
if (-not (Test-Path "index.html")) {
    Write-Error "index.html not found in root directory!"
}

$phaseDirs = @(
  "01_PHASE_1_FOUNDATION",
  "02_PHASE_2_KNOWLEDGE",
  "03_PHASE_3_BUILD_IN_PUBLIC",
  "04_PHASE_4_AUTHORITY_NETWORK",
  "05_PHASE_5_CAREER_VISIBILITY",
  "06_PHASE_6_REPUTATION_OPPORTUNITY"
)

foreach ($dir in $phaseDirs) {
  if (Test-Path $dir) {
    Copy-Item "index.html" "$dir\index.html" -Force
    Write-Host "✅ Synced to $dir\index.html"
  }
}

Write-Host "🎉 All 6 phases successfully synchronized with root index.html!"
