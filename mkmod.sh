#!/bin/bash
TGTD="vmware-host-modules"
BRANCH="workstation-12.5.9"
if ! [ -z "${1}" ]; then BRANCH=${1}; fi
# sudo /etc/init.d/vmware stop
if [ "${1}" = "clean" ]; then
  TGTM=`dkms status|grep vmware-host-modules|awk -F'[,|:]' '{print $1}'`
  if ! [ -z "${TGTM}" ]; then
    sudo systemctl stop vmware
    TGTS=`echo ${TGTM}|sed 's/\//-/g'`
    sudo make dkms_clean --file=dkms_Makefile -C ${TGTD}
    sudo rm -rf /usr/src/${TGTS}
    sudo depmod -a; exit; fi; exit; fi
echo "branch is: "${BRANCH}
if ! [ -d "${TGTD}" ]; then
  git clone https://github.com/mkubecek/vmware-host-modules.git -b ${BRANCH} ${TGTD}
  cp -f dkms_Makefile ${TGTD}/
  cp -f vmmon_Makefile ${TGTD}/vmmon-only/dkms_Makefile
  cp -f vmnet_Makefile ${TGTD}/vmnet-only/dkms_Makefile
  git config --global --add safe.directory $(pwd)/${TGTD}
  cd ${TGTD}
  if ! [ -r "patched" ]; then
    VER=$(git describe --long --always|awk -F'-' '{print $1}')
      if [ ${VER} = "w17.5.1" ]; then
        git apply ../0001-vmmon-bit-fix-for-w17.5.1.patch
        touch patched
      elif [ ${VER} = "w12.5.9" ]; then
        git apply ../0001-vmmon-bit-fix-for-w12.5.9.patch
        touch patched
      fi
  fi
cd ..
else
echo "--make--"
sudo make dkms --file=dkms_Makefile -C ${TGTD}
fi
# sudo /etc/init.d/vmware start
