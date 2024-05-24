#!/bin/sh
BOARD_DIR=$(dirname $0)

cp ./sw-description ${BINARIES_DIR}

IMG_FILES="sw-description rootfs.ext4.gz"

pushd ${BINARIES_DIR}
for f in ${IMG_FILES} ; do
	echo ${f}
done | cpio -ovL -H crc > buildroot.swu
popd