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

Write-Host ">>> Installing Hyper-V prerequisites for Docker"
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -norestart
Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -norestart

Write-host ">>> Installing VScode"
choco install -y vscode --version=1.45.1

Write-host ">>> Installing GIT"
choco install -y git --version=2.26.2

Write-host ">>> Installing AWS-Vault"
choco install -y aws-vault --version=5.4.3

Write-Host ">>> Installing Terraform"
choco install -y terraform --version=0.12.24

Write-host ">>> Installing Docker"
choco install -y docker-desktop --version=2.3.0.2
Write-host ">>> Installing Docker compose"
choco install -y docker-compose --version=1.25.4

Write-Host ">>> Installing AWS-CLI"
choco install -y awscli --version=2.0.14

Write-Host ">>> Installing Extra's like Chrome etc"
choco install -y Chrome
choco install -y firefox

Write-Host ">>> Installing Cake"
choco install -y cake.portable --version=0.37.0


Write-Host ">>> Setting up SSH for Vagrant"
New-Item -ItemType directory -Path ~/.ssh
curl https://github.com/hashicorp/vagrant/blob/master/keys/vagrant -UseBasicParsing -OutFile ~/.ssh/vagrant
curl https://github.com/hashicorp/vagrant/blob/master/keys/vagrant.pub -UseBasicParsing -OutFile ~/.ssh/vagrant.pub

Write-Host ">>> Done"