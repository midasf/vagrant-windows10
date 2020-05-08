Write-Host ">>> Configure Windows Updates"

$verbosepreference = 'continue'
Install-PackageProvider -Name Nuget -Force
Install-Module PSWindowsUpdate -Force

set-executionpolicy unrestricted -Force:$True

Get-WUList |ConvertTo-Json
# Removed to save time, will only give overview.
# Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll -IgnoreRebootRequired

Write-Host ">>> Completed Windows Updates"