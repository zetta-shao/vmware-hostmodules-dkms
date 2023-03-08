#!/bin/bash
TGTM=`dkms status vmware-host-modules|cut -f1 -d','`
if ! [ -z "${TGTM}" ]; then
echo ${TGTM}
TGTS=`echo ${TGTM}|sed 's/\//-/g'`
dkms uninstall ${TGTM}
dkms remove ${TGTM}
rm -rf /usr/src/${TGTS}
fi
./mkmod.sh
cd vmware-host-modules
make dkms --file=dkms_Makefile
