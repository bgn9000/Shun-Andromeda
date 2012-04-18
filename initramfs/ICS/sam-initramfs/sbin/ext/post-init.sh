#!/sbin/busybox sh
# Logging
#/sbin/busybox cp /data/user.log /data/user.log.bak
#/sbin/busybox rm /data/user.log
#exec >>/data/user.log
#exec 2>&1

. /res/customconfig/customconfig-helper
read_defaults
read_config

mkdir /data/.shun
chmod 777 /data/.shun
[ ! -f /data/.shun/default.profile ] && cp /res/customconfig/default.profile /data/.shun
[ ! -f /data/.shun/battery.profile ] && cp /res/customconfig/battery.profile /data/.shun
[ ! -f /data/.shun/performance.profile ] && cp /res/customconfig/performance.profile /data/.shun

if [ "$logger" == "on" ];then
insmod /lib/modules/logger.ko
fi

# disable debugging on some modules
if [ "$logger" == "off" ];then
  rm -rf /dev/log
  echo 0 > /sys/module/ump/parameters/ump_debug_level
  echo 0 > /sys/module/mali/parameters/mali_debug_level
  echo 0 > /sys/module/kernel/parameters/initcall_debug
  echo 0 > /sys//module/lowmemorykiller/parameters/debug_level
  echo 0 > /sys/module/wakelock/parameters/debug_mask
  echo 0 > /sys/module/userwakelock/parameters/debug_mask
  echo 0 > /sys/module/earlysuspend/parameters/debug_mask
  echo 0 > /sys/module/alarm/parameters/debug_mask
  echo 0 > /sys/module/alarm_dev/parameters/debug_mask
  echo 0 > /sys/module/binder/parameters/debug_mask
  echo 0 > /sys/module/xt_qtaguid/parameters/debug_mask
fi

# for ntfs automounting
insmod /lib/modules/fuse.ko

#/sbin/busybox sh /sbin/ext/busybox.sh

/sbin/busybox sh /sbin/ext/properties.sh

/sbin/busybox sh /sbin/ext/install.sh

# run this because user may have chosen not to install root at boot but he may need it later and install it using ExTweaks
/sbin/busybox sh /sbin/ext/su-helper.sh

##### Early-init phase tweaks #####
/sbin/busybox sh /sbin/ext/tweaks.sh

/sbin/busybox mount -t rootfs -o remount,ro rootfs

##### EFS Backup #####
(
# make sure that sdcard is mounted
sleep 30
/sbin/busybox sh /sbin/ext/efs-backup.sh
) &

# apply ExTweaks defaults
/res/uci.sh apply &

##### init scripts #####
(
sleep 10
/sbin/busybox sh /sbin/ext/run-init-scripts.sh
)&

#read sync < /data/sync_fifo
#rm /data/sync_fifo
