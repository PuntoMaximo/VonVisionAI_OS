#!/bin/dash


RKBIN=$BINARIES_DIR/rkbin
RKCHIP_LOADER=$2
RKCHIP=$2

# copy uboot variable file over
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3566.von/vars.txt $BINARIES_DIR/

#copy rk-kernel.dtb to fix memory issues
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3566.von/rk-kernel.dtb $BINARIES_DIR/

# copy overlays over
linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
mkdir -p $BINARIES_DIR/rockchip/overlays
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
fi

ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
boardDir=`dirname $_`

echo creating uboot.img
currentDir=`pwd`
cd $ubootName; ./make.sh;
cd $currentDir
cp $ubootName/uboot.img $BINARIES_DIR/u-boot.itb

# to take rockchip-bsp's boot loaders, rather then generating our own ...
echo creating idbloader.img
$ubootName/tools/mkimage -n rk3568 -T rksd -d $RKBIN/bin/rk35/rk3566_ddr_1056MHz_v1.08.bin:$ubootName/spl/u-boot-spl.bin $BINARIES_DIR/idbloader.img

# Generate the uboot script
echo creating extlinux boot script
mkdir $BINARIES_DIR/extlinux
echo "label rockchip
kernel /Image
fdt /rockchip/rk3566-von.dtb
append root=/dev/mmcblk1p2 earlyprintk console=ttyS2,1500000n8 rw rootwait" > $BINARIES_DIR/extlinux/extlinux.conf

# Put the device trees into the correct location
mkdir -p $BINARIES_DIR/rockchip; cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
$BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3566.von/genimage.cfg

echo
echo
echo compilation done
echo
echo
echo
echo write your image to the sdcard, don\'t forget to change OF=/dev/sdb to your sdcard drive ...
echo use the following command ...
echo
echo 'OF=/dev/sdc; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF bs=10M; else echo you are trying to overwrite your root drive; fi'
echo
