#!/sbin/busybox sh

mkdir /data/.shun
chmod 777 /data/.shun
[ ! -f /data/.shun/default.profile ] && cp /res/customconfig/default.profile /data/.shun
[ ! -f /data/.shun/battery.profile ] && cp /res/customconfig/battery.profile /data/.shun
[ ! -f /data/.shun/performance.profile ] && cp /res/customconfig/performance.profile /data/.shun


. /res/customconfig/customconfig-helper
read_defaults
read_config

if [ "$logger" == "off" ];then
rm -rf /dev/log
fi

if [ "$logger" == "on" ];then
insmod /lib/modules/logger.ko
fi

#fm radio, I have no idea why it isn't loaded in init -gm
insmod /lib/modules/Si4709_driver.ko
# for ntfs automounting
insmod /lib/modules/fuse.ko
