#!/bin/bash
TGTD="vmware-host-modules"
BRANCH="workstation-12.5.9"
if ! [ -z "${1}" ]; then BRANCH=${1}; fi
if [ "${1}" = "clean" ]; then
  TGTM=`dkms status vmware-host-modules|cut -f1 -d','`
  if ! [ -z "${TGTM}" ]; then
    systemctl stop vmware
    TGTS=`echo ${TGTM}|sed 's/\//-/g'`
    dkms uninstall ${TGTM}
    dkms remove ${TGTM}
    modprobe -r vmnet vmmon
    rm -rf /usr/src/${TGTS}
    depmod -a; exit; fi; exit; fi
echo "branch is: "${BRANCH}
if ! [ -d "${TGTD}" ]; then
git clone https://github.com/mkubecek/vmware-host-modules.git -b ${BRANCH} ${TGTD}
fi
cp -f dkms_Makefile ${TGTD}/
cp -f vmmon_Makefile ${TGTD}/vmmon-only/dkms_Makefile
cp -f vmnet_Makefile ${TGTD}/vmnet-only/dkms_Makefile
make dkms --file=dkms_Makefile -C ${TGTD}
