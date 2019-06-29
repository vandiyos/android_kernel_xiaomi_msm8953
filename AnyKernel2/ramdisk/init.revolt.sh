
#!/system/bin/sh
# Revolt kernel tweaks and parameters
# Copyright (C) 2018-2019 Soviet Development

# Allows us to get init-rc-like style
write() { echo "$2" > "$1"; }

#governor settings
write /sys/devices/system/cpu/cpu0/online 1
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor schedutil
write /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us 500
write /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us 20000
write /sys/devices/system/cpu/cpufreq/schedutil/iowait_boost_enable 0

# set default schedTune value for foreground/top-app (only affects EAS)
write /dev/stune/foreground/schedtune.prefer_idle 1
write /dev/stune/top-app/schedtune.boost 0
write /dev/stune/top-app/schedtune.prefer_idle 1
write /sys/module/cpu_boost/parameters/dynamic_stune_boost
write /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms 64

#CPU HZ
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

#Disable core control & enable thermal control
write /sys/module/msm_thermal/core_control/enabled 0
write /sys/module/msm_thermal/vdd_restriction/enabled 0
write /sys/module/msm_thermal/parameters/enabled Y

# Switch to BFQ I/O scheduler
setprop sys.io.scheduler cfq
# Disable slice_idle on supported block devices
for block in mmcblk0 mmcblk1 dm-0 dm-1 sda; do
    write /sys/block/$block/queue/iosched/slice_idle 0
done
# Set read ahead to 128 kb for external storage
# The rest are handled by qcom-post-boot
write /sys/block/mmcblk1/queue/read_ahead_kb 128
