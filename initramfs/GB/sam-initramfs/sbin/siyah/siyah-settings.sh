#!/sbin/busybox sh
exit 0

#just testing
if [ ! -e /tmp/.ikki-settings ]; then
	echo no settings found. exitting...
	exit 0
fi
echo applying settings...
(
exec 3< /tmp/.ikki-settings

while read <&3; do
	apply_settings(REPLY)
done
exec 3>&-
)
