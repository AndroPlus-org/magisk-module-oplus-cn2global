#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

(
while true
do
    setprop persist.sys.oplus.radio.globalregionlock 0,0
	setprop persist.sys.oplus.radio.haslimited false
	setprop ro.oplus.radio.checkservice false
	setprop persist.sys.oplus.bnoticetimes -200000
	setprop persist.sys.oplus.pnoticetimes -200000
	setprop gsm.sim.oplus.radio.fnoticetime -200000

    # make this script sleep for 6 hours
    sleep 6h
done
) &