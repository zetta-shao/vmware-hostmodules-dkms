#!/bin/bash
TGTD="vmware-host-modules"
BRANCH="workstation-12.5.9"
if ! [ -z "${1}" ]; then BRANCH=${1}; fi
if [ "${1}" = "clean" ]; then
  TGTM=`dkms status vmware-host-modules|awk -F'[,|:]' '{print $1}'`
  if ! [ -z "${TGTM}" ]; then
    sudo systemctl stop vmware
    TGTS=`echo ${TGTM}|sed 's/\//-/g'`
    sudo dkms uninstall ${TGTM}
    sudo dkms remove ${TGTM}
    sudo modprobe -r vmnet
    sudo modprobe -r vmmon
    sudo rm -rf /usr/src/${TGTS}
    sudo depmod -a; exit; fi; exit; fi
echo "branch is: "${BRANCH}
if ! [ -d "${TGTD}" ]; then
git clone https://github.com/mkubecek/vmware-host-modules.git -b ${BRANCH} ${TGTD}
fi
cp -f dkms_Makefile ${TGTD}/
cp -f vmmon_Makefile ${TGTD}/vmmon-only/dkms_Makefile
cp -f vmnet_Makefile ${TGTD}/vmnet-only/dkms_Makefile
cd ${TGTD}
git apply ../0001-fix-define.patch
cd ..
sudo make dkms --file=dkms_Makefile KVER=$(uname -r) -C ${TGTD}
