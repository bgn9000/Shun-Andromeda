#!/sbin/busybox sh
# root installation helper by GM
rm /data/.shun/install-root > /dev/null 2>&1
(
while : ; do
	# keep this running until we have root
	if [ -e /data/.shun/install-root ] ; then
		rm /data/.shun/install-root
		/sbin/busybox sh /sbin/ext/install.sh
        	exit 0
	fi
	if [ -e /system/xbin/su ] ; then
                exit 0
        fi
        sleep 5
done
) &
