#!/bin/sh
export USE_SEC_FIPS_MODE=true
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
INITRAMFS_TMP="/tmp/initramfs-source"

export ARCH=arm

#export CONFIG_CC_OPTIMIZE_FOR_SPEED=1
export CONFIG_CC_OPTIMIZE_FOR_FAST=1
# GCC 4.6.3
#export CROSS_COMPILE=$PARENT_DIR/arm-2012/bin_463/arm-linux-gnueabi-
# GCC 4.7.2
export CROSS_COMPILE=$PARENT_DIR/arm-2012/bin_472/arm-linux-gnueabihf-

echo config...
if [ ! -f $KERNELDIR/.config ];
then
  ./config.sh $1
fi

. $KERNELDIR/.config

echo compiling modules...
cd $KERNELDIR/
# compile whole kernel, not just modules, to get the errors sooner
nice -n 10 make V=1 -j2 || exit 1

echo initramfs...
rm -rf $INITRAMFS_TMP
rm -rf $INITRAMFS_TMP.cpio
mkdir $INITRAMFS_TMP
mkdir $INITRAMFS_TMP/lib
mkdir $INITRAMFS_TMP/lib/modules/

cd initramfs/
tar cvf $INITRAMFS_TMP/initramfs.tar *
cd ..
cd $INITRAMFS_TMP
tar xvf initramfs.tar
rm initramfs.tar
cd -
find $INITRAMFS_TMP -name .git -exec rm -rf {} \;
find -name '*.ko' -exec cp -av {} $INITRAMFS_TMP/lib/modules/ \;
cd $INITRAMFS_TMP
find | fakeroot cpio -H newc -o > $INITRAMFS_TMP.cpio 2>/dev/null
ls -lh $INITRAMFS_TMP.cpio
cd -

echo compiling kernel...
nice -n 10 make -j3 zImage CONFIG_INITRAMFS_SOURCE="$INITRAMFS_TMP.cpio" || exit 1
$KERNELDIR/mkshbootimg.py $KERNELDIR/zImage $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/payload.tar

if [ "${1}" == "ATT" ];then
	mv $KERNELDIR/zImage $KERNELDIR/zImage-att
elif [ "${1}" == "NTT" ];then
	mv $KERNELDIR/zImage $KERNELDIR/zImage-ntt
fi

