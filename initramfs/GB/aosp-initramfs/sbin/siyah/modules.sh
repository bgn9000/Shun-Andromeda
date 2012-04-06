#!/sbin/busybox sh

mkdir /data/.ikki
chmod 777 /data/.ikki

. /res/customconfig/customconfig-helper
read_defaults
read_config

/sbin/busybox mount rootfs / -o remount,rw

#### proper module support ####
#siyahver=`uname -r`
#mkdir /lib/modules/$siyahver
#for i in `ls -1 /lib/modules/*.ko`;do
#  basei=`basename $i`
#  ln /lib/modules/$basei /lib/modules/$siyahver/$basei
#done;
#depmod /lib/modules/$siyahver

/sbin/busybox mount rootfs / -o remount,ro

#android logger
if [ "$logger" == "on" ];then
insmod /lib/modules/logger.ko
fi

# for ntfs automounting
insmod /lib/modules/fuse.ko

