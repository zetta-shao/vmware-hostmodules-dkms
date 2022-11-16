#!/bin/bash
TGTM=`dkms status vmware-host-modules|cut -f1 -d','`
if ! [ -z "${TGTM}" ]; then
echo ${TGTM}
dkms remove ${TGTM}
dkms uninstall ${TGTM}
fi
make dkms --file=dkms_Makefile
