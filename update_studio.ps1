# 365 DevOps Studio Synchronization Script
# Synchronizes carousel_studio.html and assets across all 6 phase directories

$ErrorActionPreference = "Stop"

Write-Host "Verifying carousel_studio.html..."
if (-not (Test-Path "carousel_studio.html")) {
    Write-Error "carousel_studio.html not found in root directory!"
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
    Copy-Item "carousel_studio.html" "$dir\carousel_studio.html" -Force
    Write-Host "✅ Synced to $dir\carousel_studio.html"
  }
}

Write-Host "🎉 All 6 phases successfully synchronized with root carousel_studio.html!"
