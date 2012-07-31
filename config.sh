#!/bin/sh
export USE_SEC_FIPS_MODE=true
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`

export ARCH=arm

#export CONFIG_CC_OPTIMIZE_FOR_SPEED=1
export CONFIG_CC_OPTIMIZE_FOR_FAST=1
# GCC 4.6.3
#export CROSS_COMPILE=$PARENT_DIR/arm-2012/bin_463/arm-linux-gnueabi-
# GCC 4.7.2
export CROSS_COMPILE=$PARENT_DIR/arm-2012/bin_472/arm-linux-gnueabihf-

if [ ! -f $KERNELDIR/.config ];
then
	if [ "${1}" == "ATT" ];then
	  make V=1 bgn9000_att_defconfig
	elif [ "${1}" == "NTT" ];then
	  make V=1 bgn9000_ntt_defconfig
	else
	  make V=1 bgn9000_defconfig
	fi
fi
