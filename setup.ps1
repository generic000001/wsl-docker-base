[CmdletBinding()]
param(
    [switch]$VerifyOnly
)

$ErrorActionPreference = "Stop"
$distribution = "Ubuntu"
$repositoryPath = (Resolve-Path -LiteralPath $PSScriptRoot).Path

function Invoke-WslScript {
    param(
        [Parameter(Mandatory)]
        [string]$Script
    )

    & wsl.exe --distribution $distribution --cd $repositoryPath -- bash -lc $Script
    if ($LASTEXITCODE -ne 0) {
        throw "The WSL command failed with exit code $LASTEXITCODE."
    }
}

if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    throw "WSL is not installed. Open PowerShell as Administrator and run: wsl --install"
}

$distributions = @(& wsl.exe --list --quiet 2>$null) |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ }

if ($distributions -notcontains $distribution) {
    throw "The Ubuntu distribution is not installed. Open PowerShell as Administrator and run: wsl --install --distribution Ubuntu"
}

$kernel = (& wsl.exe --distribution $distribution -- uname -r 2>$null) -join "`n"
if ($kernel -notmatch "WSL2") {
    throw "Ubuntu is installed but is not using WSL2. Run: wsl --set-version Ubuntu 2"
}

if ($VerifyOnly) {
    Invoke-WslScript "sed -i 's/\\r$//' ./setup.sh ./verify.sh && ./verify.sh"
    exit 0
}

Invoke-WslScript "sed -i 's/\\r$//' ./setup.sh ./verify.sh && chmod +x ./setup.sh ./verify.sh && ./setup.sh"

Write-Host ""
Write-Host "Restarting WSL so Docker group membership takes effect..."
& wsl.exe --shutdown
if ($LASTEXITCODE -ne 0) {
    throw "WSL could not be restarted. Run 'wsl --shutdown' and then '.\setup.ps1 -VerifyOnly'."
}

Start-Sleep -Seconds 2
Write-Host "Verifying Docker installation..."
Invoke-WslScript "sed -i 's/\\r$//' ./setup.sh ./verify.sh && ./verify.sh"


