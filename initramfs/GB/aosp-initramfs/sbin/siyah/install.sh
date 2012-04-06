#!/sbin/busybox sh

mount -o remount,rw /dev/block/mmcblk0p9 /system
/sbin/busybox mount rootfs / -o remount,rw
payload_extracted=0

cd /

if [ ! -f /data/.ikki/root-installed ];
then
  if [ -f /system/xbin/su ];
  then
    echo "Superuser already exists"
  else
if [ "$payload_extracted" == "0" ];then
payload_extracted=1
eval $(/sbin/read_boot_headers /dev/block/mmcblk0p5)
load_offset=$boot_offset
load_len=$boot_len
dd bs=512 if=/dev/block/mmcblk0p5 skip=$load_offset count=$load_len | busybox tar x
fi
    rm -f /system/bin/su
    rm -f /system/xbin/su
    mkdir /system/xbin
    chmod 755 /system/xbin
    cp /tmp/misc/su /system/xbin/su
    chown 0.0 /system/xbin/su
    chmod 6755 /system/xbin/su
    ln -s /system/bin/su /system/xbin/su
    rm -f /system/app/*uper?ser.apk
    rm -f /data/app/*uper?ser.apk
    rm -rf /data/dalvik-cache/*uper?ser.apk*
    xzcat /tmp/misc/Superuser.apk.xz > /system/app/Superuser.apk
    chown 0.0 /system/app/Superuser.apk
    chmod 644 /system/app/Superuser.apk
  fi
fi;

echo "Checking if cwmanager is installed"
if [ ! -f /system/.ikki/cwmmanager3-installed ];
then
if [ "$payload_extracted" == "0" ];then
payload_extracted=1
eval $(/sbin/read_boot_headers /dev/block/mmcblk0p5)
load_offset=$boot_offset
load_len=$boot_len
dd bs=512 if=/dev/block/mmcblk0p5 skip=$load_offset count=$load_len | busybox tar x
fi
  rm /system/app/CWMManager.apk
  rm /data/dalvik-cache/*CWMManager.apk*
  rm /data/app/eu.chainfire.cfroot.cwmmanager*.apk

  xzcat /tmp/misc/CWMManager.apk.xz > /system/app/CWMManager.apk
  chown 0.0 /system/app/CWMManager.apk
  chmod 644 /system/app/CWMManager.apk
  mkdir /system/.ikki
  chmod 755 /system/.ikki
  echo 1 > /system/.ikki/cwmmanager3-installed
fi

echo "liblights..."
romtype=`cat /proc/sys/kernel/siyah_feature_set`
# only for non-cm7 roms
if [ "${romtype}a" == "0a" ] || [ "${romtype}a" == "1a" ];
then
if [ ! -f /system/.ikki/liblights-installed ];then
  lightsmd5sum=`/sbin/busybox md5sum /system/lib/hw/lights.GT-I9100.so | /sbin/busybox awk '{print $1}'`
  blnlightsmd5sum=`/sbin/busybox md5sum /res/misc/lights.GT-I9100.so | /sbin/busybox awk '{print $1}'`
  if [ "${lightsmd5sum}a" != "${blnlightsmd5sum}a" ];
  then
    echo "Copying liblights"
    /sbin/busybox mv /system/lib/hw/lights.GT-I9100.so /system/lib/hw/lights.GT-I9100.so.BAK
    /sbin/busybox cp /res/misc/lights.GT-I9100.so /system/lib/hw/lights.GT-I9100.so
    /sbin/busybox chown 0.0 /system/lib/hw/lights.GT-I9100.so
    /sbin/busybox chmod 644 /system/lib/hw/lights.GT-I9100.so
  fi
  echo 1 > /system/.ikki/liblights-installed
fi
fi

echo "ntfs-3g..."
if [ ! -s /system/xbin/ntfs-3g ];
then
if [ "$payload_extracted" == "0" ];then
payload_extracted=1
eval $(/sbin/read_boot_headers /dev/block/mmcblk0p5)
load_offset=$boot_offset
load_len=$boot_len
dd bs=512 if=/dev/block/mmcblk0p5 skip=$load_offset count=$load_len | busybox tar x
fi
  xzcat /tmp/misc/ntfs-3g.xz > /system/xbin/ntfs-3g
  chown 0.0 /system/xbin/ntfs-3g
  chmod 755 /system/xbin/ntfs-3g
fi
rm -rf /tmp/misc/
/sbin/busybox mount rootfs / -o remount,ro
mount -o remount,ro /dev/block/mmcblk0p9 /system
