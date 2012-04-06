#!/sbin/busybox sh
#
# 89system_tweak V66
# by zacharias.maladroit
# modifications and ideas taken from: ckMod SSSwitch by voku1987 and "battery tweak" (collin_ph@xda)
# OOM/LMK settings by Juwe11
# network security settings inspired by various security, server guides on the web

# ==============================================================
# ==============================================================
# ==============================================================
# One-time tweaks to apply on every boot
# ==============================================================
# ==============================================================
# ==============================================================
# =========
STL=`ls -d /sys/block/stl*`;
BML=`ls -d /sys/block/bml*`;
MMC=`ls -d /sys/block/mmc*`;
ZRM=`ls -d /sys/block/zram*`;

# Optimize non-rotating storage; 
for i in $STL $BML $MMC $ZRM;
do
	#IMPORTANT!
	if [ -e $i/queue/rotational ]; 
	then
		echo 0 > $i/queue/rotational; 
	fi;
	if [ -e $i/queue/nr_requests ];
	then
		echo 8192 > $i/queue/nr_requests; # for starters: keep it sane
	fi;
	#CFQ specific
	if [ -e $i/queue/iosched/back_seek_penalty ];
	then 
		echo 1 > $i/queue/iosched/back_seek_penalty;
	fi;
	#CFQ specific
	if [ -e $i/queue/iosched/low_latency ];
	then
		echo 1 > $i/queue/iosched/low_latency;
	fi;
	#CFQ Specific
	if [ -e $i/queue/iosched/slice_idle ];
	then 
		echo 0 > $i/queue/iosched/slice_idle; # previous: 1
	fi;
	# deadline/VR/SIO scheduler specific
	if [ -e $i/queue/iosched/fifo_batch ];
	then
		echo 1 > $i/queue/iosched/fifo_batch;
	fi;
	if [ -e $i/queue/iosched/writes_starved ];
	then
		echo 1 > $i/queue/iosched/writes_starved;
	fi;
	#CFQ specific
	if [ -e $i/queue/iosched/quantum ];
	then
		echo 8 > $i/queue/iosched/quantum;
	fi;
	#VR Specific
	if [ -e $i/queue/iosched/rev_penalty ];
	then
		echo 1 > $i/queue/iosched/rev_penalty;
	fi;
	if [ -e $i/queue/rq_affinity ];
	then
	echo "1"   >  $i/queue/rq_affinity;   
	fi;
done;

#disable iostats to reduce overhead  # idea by kodos96 - thanks !
for k in $STL $BML $MMC $ZRM;
do
	if [ -e $k/queue/iostats ];
	then
		echo "0" > $k/queue/iostats;
	fi;
done;

# Remount all partitions with noatime
for k in $(busybox mount | grep relatime | cut -d " " -f3);
do
#sync;
busybox mount -o remount,noatime $k;
done;


##         /bin/echo "0"   >  $i/queue/nomerges
#          echo "128" >  $i/queue/max_sectors_kb


# Optimize for read- & write-throughput; 
# Optimize for readahead; 

for i in $STL $BML $MMC $ZRM; 
do
	if [ -e $i/queue/read_ahead_kb ];
	then
		echo "256" >  $i/queue/read_ahead_kb; # yes - I know - this is evil ^^, might help with battery runtime still (in certain workloads)
	fi;
                                     
done;

# =========
# TWEAKS: raising read_ahead_kb cache-value for sd card to 2048 [not needed with above tweak but just in case it doesn't get applied]
# =========
#echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb

# improved approach of the readahead-tweak:


if [ -e /sys/devices/virtual/bdi/179:0/read_ahead_kb ];
then
    echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;
fi;
	
if [ -e /sys/devices/virtual/bdi/179:8/read_ahead_kb ];
  then
    echo "1024" > /sys/devices/virtual/bdi/179:8/read_ahead_kb;
fi;

if [ -e /sys/devices/virtual/bdi/179:16/read_ahead_kb ];
  then
    echo "1024" > /sys/devices/virtual/bdi/179:16/read_ahead_kb;
fi;

if [ -e /sys/devices/virtual/bdi/179:28/read_ahead_kb ];
  then
    echo "1024" > /sys/devices/virtual/bdi/179:28/read_ahead_kb;
fi;

if [ -e /sys/devices/virtual/bdi/179:33/read_ahead_kb ];
  then
    echo "1024" > /sys/devices/virtual/bdi/179:33/read_ahead_kb;
fi;

if [ -e /sys/devices/virtual/bdi/default/read_ahead_kb ];
  then
    echo "256" > /sys/devices/virtual/bdi/default/read_ahead_kb;
fi;

sysctl -w vm.dirty_writeback_centisecs=2000;
sysctl -w vm.dirty_expire_centisecs=200;

# Optimize for read- & write-throughput; 
# Optimize for readahead; 
# =========
# TWEAKS: overall
# =========
setprop ro.telephony.call_ring.delay 1000; # let's minimize the time Android waits until it rings on a call

if [ "`getprop dalvik.vm.heapsize | sed 's/m//g'`" -lt 64 ];then
setprop dalvik.vm.heapsize 64m; # leave that setting to cyanogenmod settings or uncomment it if needed
fi;

setprop wifi.supplicant_scan_interval 120; # higher is not recommended, scans while not connected anyway so shouldn't affect while connected

if [ "`getprop windowsmgr.max_events_per_sec`" -lt 60 ];then
setprop windowsmgr.max_events_per_sec 60; # smoother GUI
fi

