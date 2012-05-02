#!/sbin/busybox sh
if [ ! -f /data/.shun/efsbackup.tar.gz ];
then
  mkdir /data/.shun
  chmod 777 /data/.shun
  /sbin/busybox tar zcvf /data/.shun/efsbackup.tar.gz /efs
  /sbin/busybox cat /dev/block/mmcblk0p1 > /data/.shun/efsdev-mmcblk0p1.img
  /sbin/busybox gzip /data/.shun/efsdev-mmcblk0p1.img
  #make sure that sdcard is mounted, media scanned..etc
  (
    sleep 500
    /sbin/busybox cp /data/.shun/efs* /sdcard
  ) &
fi

