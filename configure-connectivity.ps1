powershell -NoProfile -ExecutionPolicy unrestricted -Command "&([scriptblock]::Create((Invoke-WebRequest -useb 'https://chocolatey.org/install.ps1')))"

Set-ExecutionPolicy Unrestricted -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
Write-Host "Install Chocolatey"
$env:chocolateyVersion = '0.10.15'
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Install sdelete"
choco install sdelete -y --version 2.02 --ignorechecksum

Write-Host "Disable Windows Updates"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /d 1 /t REG_DWORD /f /reg:64
sc.exe config wuauserv start= disabled

Write-Host "Disable Windows Store Updates"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /d 2 /t REG_DWORD /f /reg:64

Write-Host "Disable Maintenance"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f

Write-Host "Disable UAC"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f

Write-Host "Enable Remote Desktop"
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall add rule name="Remote Desktop" dir=in localport=3389 protocol=TCP action=allow


Write-Host "Configure SSH key"
If (Test-Path C:/Users/Administrator/.ssh) { Remove-Item -Recurse -Force C:/Users/Administrator/.ssh }
mkdir -Force C:/Users/Administrator/.ssh


Write-Host "Install OpenSSH"
netsh advfirewall firewall add rule name="Autounattend SSH" dir=in localport=22 protocol=TCP action=allow

choco install openssh -y --version 7.7.2.1 -params '"/SSHServerFeature"' # /PathSpecsToProbeForShellEXEString:$env:windir\system32\windowspowershell\v1.0\powershell.exe"'

sc.exe config sshd start=auto
net start sshd
#netsh advfirewall firewall delete rule name="Autounattend SSH"

Write-Host ">>> Setting up WinRM"
# Supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

# Set network to private
$ifaceinfo = Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex $ifaceinfo.InterfaceIndex -NetworkCategory Private 

# Set up WinRM and configure some things
winrm quickconfig -q
winrm s "winrm/config" '@{MaxTimeoutms="1800000"}'
winrm s "winrm/config/winrs" '@{MaxMemoryPerShellMB="2048"}'
winrm s "winrm/config/service" '@{AllowUnencrypted="true"}'
winrm s "winrm/config/service/auth" '@{Basic="true"}'

# Enable the WinRM Firewall rule, which will likely already be enabled due to the 'winrm quickconfig' command above
Enable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

sc.exe config winrm start= auto

exit 0