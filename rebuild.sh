#!/bin/sh
rm modules.* Module.symvers .missing-syscalls.d .version
rm -f arch/arm/boot/zImage zImage arch/arm/boot/compressed/*.o arch/arm/boot/compressed/.*.cmd arch/arm/boot/compressed/vmlinux arch/arm/boot/compressed/piggy.xzkern arch/arm/boot/compressed/ashldi3.S arch/arm/boot/compressed/vmlinux.lds arch/arm/boot/compressed/lib1funcs.S arch/arm/boot/Image arch/arm/boot/.*.cmd 
rm -rf .tmp* .vm* ..tmp* vmlinux* System.map usr/.initramfs_data.* usr/*.o usr/.*.cmd usr/initramfs_data.cpio usr/gen_init_cpio usr/modules.* init/*.o init/.*.cmd init/modules.*

# 1 : SAM or AOSP, 2 : ICS or GB, 3 : NTT or ATT or "" (means international) 
./build.sh $1 $2 $3
