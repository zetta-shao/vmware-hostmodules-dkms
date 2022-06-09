# vmware-hostmodules-dkms
This is vmware-host-modules DKMS support package for VMware workstation/player linux version, when install in ubuntu, this DKMS package will auto-build and install "vmware-host-modules" kernel modules when newer kernel version upgraded.

## Before install
Before install vmware-host-modules, check vmware player or workstation installed production name and version **in GUI concole**, example:

`vmware-installer -l`
> Product Name         Product Version<br>
> ==================== ====================<br>
> **vmware-workstation   12.5.5**.999999<br>

This is workstation, 12.5.5, remember there.<br>
note: vmware-host-modules maintain earlest workstation/player version is 12.5

## Download scripts
`git clone https://github.com/zetta-shao/vmware-hostmodules-dkms.git`

## Edit script
edit mkmod.sh, change "BRANCH" to your workstation or player version, default is workstation 12.5.9

## Install required package and run
`sudo apt-get install build-essential git dkms`<br>
`sudo ./mkmod.sh`

if run mkmod.sh again and got some problem, try run<br>
`sudo ./mkmod.sh clean`
to clean exist DKMS package and build files.
