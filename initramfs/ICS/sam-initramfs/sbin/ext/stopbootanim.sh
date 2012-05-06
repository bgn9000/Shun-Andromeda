#!/sbin/busybox sh

if [ ! -f /data/.shun/nobootanimation ]; then
  stop samsungani
fi;
