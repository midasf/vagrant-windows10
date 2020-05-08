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
* **[Virtualbox](https://www.virtualbox.org/)**
* **An RDP client** 



