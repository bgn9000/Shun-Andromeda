#!/sbin/busybox sh
if [ ! -f /data/.ikki/efsbackup.tar.gz ];
then
  mkdir /data/.ikki
  chmod 777 /data/.ikki
  /sbin/busybox tar zcvf /data/.ikki/efsbackup.tar.gz /efs
  /sbin/busybox cat /dev/block/mmcblk0p1 > /data/.ikki/efsdev-mmcblk0p1.img
  /sbin/busybox gzip /data/.ikki/efsdev-mmcblk0p1.img
  #make sure that sdcard is mounted, media scanned..etc
  (
    sleep 500
    /sbin/busybox cp /data/.ikki/efs* /sdcard
  ) &
fi

