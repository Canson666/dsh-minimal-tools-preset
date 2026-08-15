# install.ps1 — install the minimal-tools agent preset for DeepSeek Harness
# Usage:
#   One-command (downloads from GitHub when not run from a checkout):
#     irm https://raw.githubusercontent.com/Canson666/dsh-minimal-tools-preset/main/install.ps1 | iex
#   From a repo checkout:
#     powershell -ExecutionPolicy Bypass -File .\install.ps1
#
# Works on Windows PowerShell 5.1 and PowerShell 7+. This file is UTF-8 with a
# BOM so Windows PowerShell 5.1 renders the Chinese messages correctly.

$ErrorActionPreference = 'Stop'

$repo = 'Canson666/dsh-minimal-tools-preset'
$repoName = Split-Path -Leaf $repo
$branch = 'main'

$dshHome = $env:DSH_HOME
if (-not $dshHome) { $dshHome = Join-Path $HOME '.dsh' }
$presetRoot = Join-Path $dshHome '.agent-presets'
$dst = Join-Path $presetRoot 'minimal-tools'

function Install-From([string]$src) {
    if (-not (Test-Path (Join-Path $src 'agent.cordis.yml'))) {
        throw "agent.cordis.yml not found at $src"
    }
    New-Item -ItemType Directory -Path $presetRoot -Force | Out-Null
    if (Test-Path $dst) {
        Write-Host "Updating existing preset at $dst" -ForegroundColor Yellow
        Remove-Item $dst -Recurse -Force
    }
    Copy-Item $src $dst -Recurse -Force
}

# Local checkout mode: the preset files sit next to this script.
$scriptDir = $null
if ($PSCommandPath) { $scriptDir = Split-Path -Parent $PSCommandPath }
$src = $null
if ($scriptDir) {
    $candidate = Join-Path $scriptDir 'minimal-tools'
    if (Test-Path (Join-Path $candidate 'agent.cordis.yml')) { $src = $candidate }
}

if ($src) {
    Install-From $src
}
else {
    # Remote mode (e.g. `irm ... | iex` outside a checkout): download from GitHub.
    Write-Host "Local preset files not found - downloading from GitHub ($repo@$branch)..." -ForegroundColor Cyan
    $tmp = Join-Path $env:TEMP ("dsh-mtp-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        $zip = Join-Path $tmp 'repo.zip'
        Invoke-WebRequest -Uri "https://codeload.github.com/$repo/zip/refs/heads/$branch" -OutFile $zip -UseBasicParsing
        Expand-Archive -Path $zip -DestinationPath $tmp
        Install-From (Join-Path $tmp "$repoName-$branch\minimal-tools")
    }
    finally {
        Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Installed 'minimal-tools' preset -> $dst" -ForegroundColor Green
Write-Host "Start a NEW session in the GUI and pick 极简+工具包." -ForegroundColor Cyan
