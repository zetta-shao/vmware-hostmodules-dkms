#!/bin/bash
TGTD="vmware-host-modules"
BRANCH="workstation-12.5.9"
if ! [ -z "${1}" ]; then BRANCH=${1}; fi
if [ "${1}" = "clean" ]; then
rm -rf /usr/src/vmware-host-modules-*
rm -rf /var/lib/dkms/vmware-host-modules
rm -rf ${TGTD}
rmmod vmnet
rmmod vmmon
rm -f /lib/modules/*/updates/dkms/vmmon.ko /lib/modules/*/updates/dkms/vmnet.ko
depmod -a
exit
fi
echo "branch is: "${BRANCH}
if ! [ -d "${TGTD}" ]; then
git clone https://github.com/mkubecek/vmware-host-modules.git -b ${BRANCH} ${TGTD}
fi
cp -f dkms_Makefile ${TGTD}/
cp -f vmmon_Makefile ${TGTD}/vmmon-only/dkms_Makefile
cp -f vmnet_Makefile ${TGTD}/vmnet-only/dkms_Makefile
make dkms --file=dkms_Makefile -C ${TGTD}
