# Packer Atlas-W10

In essence a packerbuild to create a standard for Atlas members to work with.


* Use an existing, vanilla, Windows 10 x64 Enterprise trial ISO
* Enable SSH (using a default admin user.)
* Create a `vagrant` user (as is the style)
* Grab all the Windows updates is can
* Turn off Hibernation
* Turn on RDP
* Enable high performance mode
* Install choco and needed tools for daily usage.


## Requirements

* **A copy of the [Windows 10 x64 Enterprise Trial](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise)**
* **Packer / Vagrant**  
* **Hyper-v**
* **An RDP client** 

## Installed features
* **Hyper-V**
* **Docker Desktop**
* **Docker Compose**
* **VSCode**
* **Terraform**
* **AWSCLI**
* **AWS-Vault**
* **Cake build**
* **Chrome**
* **Firefox**

## How to build
```
packer build -force -only=hyperv-iso -var 'iso_path=C:\dump\18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso' -var 'iso_md5=9ef81b6a101afd57b2dbfa44d5c8f7bc94ff45b51b82c5a1f9267ce2e63e9f53' packer.json
```

