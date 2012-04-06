#!/sbin/busybox sh
# thanks to hardcore and nexxx
# some parameters are taken from http://forum.xda-developers.com/showthread.php?t=1292743 (highly recommended to read)

. /res/customconfig/customconfig-helper
read_defaults
read_config

#apply default config
(
sleep 5
/res/uci.sh apply
) &

# IPv6 privacy tweak
#if /sbin/busybox [ "`/sbin/busybox grep IPV6PRIVACY /system/etc/tweaks.conf`" ]; then
  echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr
#fi

# enable SCHED_MC
echo $sched_mc_power_savings > /sys/devices/system/cpu/sched_mc_power_savings
# Enable AFTR, default:2
echo $enable_mask > /sys/module/cpuidle/parameters/enable_mask

# TCP tweaks
echo "2" > /proc/sys/net/ipv4/tcp_syn_retries
echo "2" > /proc/sys/net/ipv4/tcp_synack_retries
echo "10" > /proc/sys/net/ipv4/tcp_fin_timeout

#thanks to pikachu01@XDA
/sbin/busybox sh /sbin/siyah/thunderbolt.sh
sysctl -w kernel.sched_min_granularity_ns=200000;
sysctl -w kernel.sched_latency_ns=400000;
sysctl -w kernel.sched_wakeup_granularity_ns=100000;
setprop debug.performance.tuning 1; 
setprop video.accelerate.hw 1;
setprop debug.sf.hw 1;
echo NO_GENTLE_FAIR_SLEEPERS > /sys/kernel/debug/sched_features
#these are from NEAK kernel. I don't know where simone got them or if they do any good, but it seems that they won't harm anything
renice 6 `pidof kswapd0`
sysctl -w vm.vfs_cache_pressure=70
echo "8" > /proc/sys/vm/page-cluster;
echo "64000" > /proc/sys/kernel/msgmni;
echo "64000" > /proc/sys/kernel/msgmax;
echo "10" > /proc/sys/fs/lease-break-time;
sysctl -w kernel.sem="500 512000 100 2048";
sysctl -w kernel.shmmax=268435456;
