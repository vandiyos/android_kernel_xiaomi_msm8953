
#!/system/bin/sh
# Revolt kernel tweaks and parameters
# Copyright (C) 2018-2019 Soviet Development

#governor settings
echo 1 > /sys/devices/system/cpu/cpu0/online
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 500 > /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/schedutil/iowait_boost_enable

# set default schedTune value for foreground/top-app (only affects EAS)
echo 1 > /dev/stune/foreground/schedtune.prefer_idle
echo 0 > /dev/stune/top-app/schedtune.boost
echo 1 > /dev/stune/top-app/schedtune.prefer_idle
echo 0 > /sys/module/cpu_boost/parameters/dynamic_stune_boost
echo 64 >/sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

#CPU HZ
echo 652000 >  /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 2016000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

#Disable core control & enable thermal control
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo 0 > /sys/module/msm_thermal/vdd_restriction/enabled
echo Y > /sys/module/msm_thermal/parameters/enabled

# Switch to BFQ I/O scheduler
setprop sys.io.scheduler cfq
# Disable slice_idle on supported block devices
for block in mmcblk0 mmcblk1 dm-0 dm-1 sda; do
    echo 0 > /sys/block/$block/queue/iosched/slice_idle
done
# Set read ahead to 128 kb for external storage
# The rest are handled by qcom-post-boot
echo 0 > /sys/block/mmcblk1/queue/read_ahead_kb
