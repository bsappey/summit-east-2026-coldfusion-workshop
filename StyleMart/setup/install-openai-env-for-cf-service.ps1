# Run as Administrator. Sets BOTH OpenAI env vars for:
#   1) Machine scope (all processes)
#   2) ColdFusion Windows service Environment key (picked up on next service start)
#
# Usage:
#   .\install-openai-env-for-cf-service.ps1 -ApiKey "sk-your-key-here"
#
param(
    [Parameter(Mandatory = $true)]
    [string] $ApiKey
)

$ErrorActionPreference = "Stop"
$serviceName = "ColdFusion 2025 Application Server"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Run this script in an elevated (Administrator) PowerShell window."
}

[Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $ApiKey, "Machine")
[Environment]::SetEnvironmentVariable("CF_TRAINING_OPENAI_API_KEY", $ApiKey, "Machine")
Write-Host "[ok] Machine environment variables set."

$svcEnv = "HKLM:\SYSTEM\CurrentControlSet\Services\$serviceName\Environment"
if (-not (Test-Path $svcEnv)) {
    New-Item -Path $svcEnv -Force | Out-Null
}
New-ItemProperty -Path $svcEnv -Name "OPENAI_API_KEY" -Value $ApiKey -PropertyType String -Force | Out-Null
New-ItemProperty -Path $svcEnv -Name "CF_TRAINING_OPENAI_API_KEY" -Value $ApiKey -PropertyType String -Force | Out-Null
Write-Host "[ok] Service Environment registry key updated: $svcEnv"

Write-Host ""
Write-Host "Now restart ColdFusion (Administrator):"
Write-Host "  Restart-Service -Name '$serviceName' -Force"
Write-Host ""
Write-Host "Then open: .../StyleMart/setup/verify-openai-env.cfm"
