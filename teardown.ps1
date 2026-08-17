[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$distribution = "Ubuntu"

if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    throw "WSL is not installed."
}

$distributions = @(& wsl.exe --list --quiet 2>$null) |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ }

if ($distributions -notcontains $distribution) {
    Write-Host "The '$distribution' distribution is already absent."
    exit 0
}

if (-not $Force) {
    $confirmation = Read-Host "This permanently deletes '$distribution' and all files, packages, Docker data, and volumes. Type DELETE to continue"
    if ($confirmation -cne "DELETE") {
        throw "Teardown cancelled."
    }
}

if ($Force -or $PSCmdlet.ShouldProcess($distribution, "Unregister WSL distribution")) {
    & wsl.exe --unregister $distribution
    if ($LASTEXITCODE -ne 0) {
        throw "WSL could not unregister '$distribution'."
    }

    Write-Host "The '$distribution' environment was deleted."
}
