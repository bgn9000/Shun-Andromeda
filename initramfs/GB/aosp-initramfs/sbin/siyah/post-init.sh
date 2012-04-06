#!/sbin/busybox sh
# Logging
#/sbin/busybox cp /data/user.log /data/user.log.bak
#/sbin/busybox rm /data/user.log
#exec >>/data/user.log
#exec 2>&1

/sbin/busybox sh /sbin/siyah/modules.sh

#/sbin/busybox sh /sbin/siyah/busybox.sh

/sbin/busybox sh /sbin/siyah/properties.sh

/sbin/busybox sh /sbin/siyah/install.sh

##### Early-init phase tweaks #####
/sbin/busybox sh /sbin/siyah/tweaks.sh

##### Modify build.prop #####
if [ "`/sbin/busybox grep -i persist.adb.notify /system/build.prop`" ];
then
echo already there...
else
mount -o remount,rw /dev/block/mmcblk0p9 /system
echo persist.adb.notify=0 >> /system/build.prop
mount -o remount,ro /dev/block/mmcblk0p9 /system
fi;

#battery calibration
#/sbin/busybox sh /sbin/siyah/batt-cal.sh

/sbin/busybox mount rootfs / -o remount,ro

##### EFS Backup #####
(
# make sure that sdcard is mounted
sleep 30
/sbin/busybox sh /sbin/siyah/efs-backup.sh
) &

##### init scripts #####
(
sleep 12
/sbin/busybox sh /sbin/siyah/run-init-scripts.sh
)&

#read sync < /data/sync_fifo
#rm /data/sync_fifo
