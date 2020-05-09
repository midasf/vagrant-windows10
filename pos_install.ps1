Write-Host ">>> Enable Pagefile"

$computer = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$computer.AutomaticManagedPagefile = $True
$computer.Put()

Write-Host ">>> Disable Windows Update"
Stop-Service wuauserv
Set-Service wuauserv -StartupType Disabled

Write-Host ">>> Set Powerplan to High Performance"
$powerPlan = Get-WmiObject -Namespace root\cimv2\power -Class Win32_PowerPlan -Filter "ElementName = 'High Performance'"
$powerPlan.Activate()

Write-Host ">>> Set Advanced Performance Settings for best performance"
$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
try {
    $s = (Get-ItemProperty -ErrorAction stop -Name visualfxsetting -Path $path).visualfxsetting 
    if ($s -ne 2) {
        Set-ItemProperty -Path $path -Name 'VisualFXSetting' -Value 2  
        }
    }
catch {
    New-ItemProperty -Path $path -Name 'VisualFXSetting' -Value 2 -PropertyType 'DWORD'
}

Write-host ">>> Installing VScode"
choco install vscode

Write-host ">>> Installing AWS-Vault"
choco install -y aws-vault

Write-Host ">>> Installing Terraform"
choco install -y terraform

Write-host ">>> Installing Docker"
choco install -y docker-desktop
Write-host ">>> Installing Docker compose"
choco install -y docker-compose

Write-Host ">>> Installing AWS-CLI"
choco install -y awscli

Write-Host ">>> Done"