#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

#resetprop ro.boot.hwc GLOBAL
#resetprop ro.boot.hwcountry GLOBAL

maybe_set_prop() {
    local prop="$1"
    local contains="$2"
    local value="$3"

    if [[ "$(getprop "$prop")" == *"$contains"* ]]; then
        resetprop "$prop" "$value"
    fi
}

maybe_set_prop gsm.sim.operator.numeric "," "44011,44011"
maybe_set_prop gsm.sim.operator.iso-country "," "jp,jp"

# Disable CN GMS restriction
mount -o ro,bind $MODDIR/xml/permissions/oplus.feature.control_cn_gms.xml /my_bigball/etc/permissions/oplus.feature.control_cn_gms.xml
mount -o ro,bind $MODDIR/xml/permissions/oplus_google_cn_gms_features.xml /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
mount -o ro,bind $MODDIR/xml/permissions/oplusfeature.region_cn.com.oplus.battery.xml /my_bigball/etc/permissions/oplusfeature.region_cn.com.oplus.battery.xml

mount -o ro,bind $MODDIR/xml/permissions/EuiccGoogle_grant_permissions_list.xml /my_bigball/etc/permissions/EuiccGoogle_grant_permissions_list.xml
mount -o ro,bind $MODDIR/xml/EuiccGoogle /my_bigball/priv-app/EuiccGoogle