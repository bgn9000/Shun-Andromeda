#!/sbin/busybox sh

extract_payload()
{
  payload_extracted=1
  chmod 755 /sbin/read_boot_headers
  eval $(/sbin/read_boot_headers /dev/block/mmcblk0p5)
  load_offset=$boot_offset
  load_len=$boot_len
  cd /
  dd bs=512 if=/dev/block/mmcblk0p5 skip=$load_offset count=$load_len | tar x
}

. /res/customconfig/customconfig-helper
read_defaults
read_config

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs
payload_extracted=0

cd /

if [ "$install_root" == "on" ];
then
  if [ -s /system/xbin/su ];
  then
    echo "Superuser already exists"
  else
    if [ "$payload_extracted" == "0" ];then
      extract_payload
    fi
    rm -f /system/bin/su
    rm -f /system/xbin/su
    mkdir /system/xbin
    chmod 755 /system/xbin
    xzcat /tmp/misc/su.xz > /system/xbin/su
    chown 0.0 /system/xbin/su
    chmod 6755 /system/xbin/su

    rm -f /system/app/*uper?ser.apk
    rm -f /system/app/?uper?u.apk
    rm -f /system/app/*chainfire?supersu*.apk
    rm -f /data/app/*uper?ser.apk
    rm -f /data/app/?uper?u.apk
    rm -f /data/app/*chainfire?supersu*.apk
    rm -rf /data/dalvik-cache/*uper?ser.apk*
    rm -rf /data/dalvik-cache/*chainfire?supersu*.apk*
    xzcat /tmp/misc/Superuser.apk.xz > /system/app/Superuser.apk
    chown 0.0 /system/app/Superuser.apk
    chmod 644 /system/app/Superuser.apk
  fi
fi;

echo "Checking if cwmanager is installed"
if [ ! -f /system/.shun/cwmmanager3-installed ];
then
  if [ "$payload_extracted" == "0" ];then
    extract_payload
  fi
  rm /system/app/CWMManager.apk
  rm /data/dalvik-cache/*CWMManager.apk*
  rm /data/app/eu.chainfire.cfroot.cwmmanager*.apk

  xzcat /tmp/misc/CWMManager.apk.xz > /system/app/CWMManager.apk
  chown 0.0 /system/app/CWMManager.apk
  chmod 644 /system/app/CWMManager.apk
  mkdir /system/.shun
  chmod 755 /system/.shun
  echo 1 > /system/.shun/cwmmanager3-installed
fi

echo "liblights..."
romtype=`cat /proc/sys/kernel/rom_feature_set`
# only for non-cm7 roms
#if [ "${romtype}a" == "0a" ];
#then
#if [ ! -f /system/.shun/liblights-installed ];then
  lightsmd5sum=`/sbin/busybox md5sum /system/lib/hw/lights.exynos4.so | /sbin/busybox awk '{print $1}'`
  blnlightsmd5sum=`/sbin/busybox md5sum /res/misc/lights.exynos4.so | /sbin/busybox awk '{print $1}'`
  if [ "${lightsmd5sum}a" != "${blnlightsmd5sum}a" ];
  then
    echo "Copying liblights"
    /sbin/busybox mv /system/lib/hw/lights.exynos4.so /system/lib/hw/lights.exynos4.so.BAK
    /sbin/busybox cp /res/misc/lights.exynos4.so /system/lib/hw/lights.exynos4.so
    /sbin/busybox chown 0.0 /system/lib/hw/lights.exynos4.so
    /sbin/busybox chmod 644 /system/lib/hw/lights.exynos4.so
  fi
  echo 1 > /system/.shun/liblights-installed
#fi
#fi

echo "ntfs-3g..."
if [ ! -s /system/xbin/ntfs-3g ];
then
  if [ "$payload_extracted" == "0" ];then
    extract_payload
  fi
  xzcat /tmp/misc/ntfs-3g.xz > /system/xbin/ntfs-3g
  chown 0.0 /system/xbin/ntfs-3g
  chmod 755 /system/xbin/ntfs-3g
fi

echo "Camera fix..."
if [ ! -s /system/lib/hw/camera.exynos4.so_TT-ori ];
then
  if [ "$payload_extracted" == "0" ];then
    extract_payload
  fi
  mv /system/lib/hw/camera.exynos4.so /system/lib/hw/camera.exynos4.so_TT-ori
  xzcat /tmp/misc/camera.exynos4.so.xz > /system/lib/hw/camera.exynos4.so
  chown 0.0 /system/lib/hw/camera.exynos4.so
  chmod 755 /system/lib/hw/camera.exynos4.so
fi
if [ ! -s /system/lib/hw/hwcomposer.exynos4.so_TT-ori ];
then
  if [ "$payload_extracted" == "0" ];then
    extract_payload
  fi
  mv /system/lib/hw/hwcomposer.exynos4.so /system/lib/hw/hwcomposer.exynos4.so_TT-ori
  xzcat /tmp/misc/hwcomposer.exynos4.so.xz > /system/lib/hw/hwcomposer.exynos4.so
  chown 0.0 /system/lib/hw/hwcomposer.exynos4.so
  chmod 755 /system/lib/hw/hwcomposer.exynos4.so
fi

rm -rf /tmp/misc/
/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
