#!/bin/bash
TGTD="vmware-host-modules"
BRANCH="workstation-12.5.9"
if ! [ -z "${1}" ]; then BRANCH=${1}; fi
sudo /etc/init.d/vmware stop
if [ "${1}" = "clean" ]; then
  TGTM=`dkms status|grep vmware-host-modules|awk -F'[,|:]' '{print $1}'`
  if ! [ -z "${TGTM}" ]; then
    sudo systemctl stop vmware
    TGTS=`echo ${TGTM}|sed 's/\//-/g'`
    sudo dkms uninstall ${TGTM}
    sudo make dkms_clean --file=dkms_Makefile -C ${TGTD}
    sudo rm -rf /usr/src/${TGTS}
    sudo depmod -a;
    if [ -d '/var/lib/dkms/vmware-host-modules' ]; then 
      sudo rm -rf /var/lib/dkms/vmware-host-modules; 
    fi
    exit; fi; exit; fi
echo "branch is: "${BRANCH}
if ! [ -d "${TGTD}" ]; then
  git clone https://github.com/mkubecek/vmware-host-modules.git -b ${BRANCH} ${TGTD}
  git config --global --add safe.directory $(pwd)/${TGTD}
fi
cp -f dkms_Makefile ${TGTD}/
cp -f vmmon_Makefile ${TGTD}/vmmon-only/dkms_Makefile
cp -f vmnet_Makefile ${TGTD}/vmnet-only/dkms_Makefile
cd ${TGTD}
git reset $(git log|head -1|awk '{print $2}') --hard
git checkout ${BRANCH}
VER=$(git describe --long --always|awk -F'-' '{print $1}')
if [ ${VER} = "w17.5.1" ]; then
  git apply ../0001-vmmon-bit-fix-for-w17.5.1.patch
  touch patched
elif [ ${VER} = "w17.0.2" ]; then
  git apply ../0001-vmmon-bit-fix-for-w17.0.2.patch
elif [ ${VER} = "w12.5.9" ]; then
  git apply ../0001-vmmon-bit-fix-for-w12.5.9.patch
  touch patched
fi
cd ..
sudo make dkms --file=dkms_Makefile -C ${TGTD}
sudo /etc/init.d/vmware start
