# install.ps1 — install the minimal-tools agent preset for DeepSeek Harness
# Usage: powershell -ExecutionPolicy Bypass -File .\install.ps1
#        irm https://raw.githubusercontent.com/<you>/<repo>/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $repoRoot -or $repoRoot -eq '') { $repoRoot = (Get-Location).Path }

$src = Join-Path $repoRoot 'minimal-tools'
if (-not (Test-Path (Join-Path $src 'agent.cordis.yml'))) {
    throw "agent.cordis.yml not found at $src — run this script from the repo root."
}

$dshHome = $env:DSH_HOME
if (-not $dshHome) { $dshHome = Join-Path $HOME '.dsh' }
$presetRoot = Join-Path $dshHome '.agent-presets'
$dst = Join-Path $presetRoot 'minimal-tools'

New-Item -ItemType Directory -Path $presetRoot -Force | Out-Null
if (Test-Path $dst) {
    Write-Host "Updating existing preset at $dst" -ForegroundColor Yellow
    Remove-Item $dst -Recurse -Force
}
Copy-Item $src $dst -Recurse -Force

Write-Host "Installed 'minimal-tools' preset -> $dst" -ForegroundColor Green
Write-Host "Start a NEW session in the GUI and pick 极简+工具包." -ForegroundColor Cyan
