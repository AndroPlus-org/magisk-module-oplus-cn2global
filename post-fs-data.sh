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

BRAND=$(getprop ro.com.google.clientidbase)

# Disable CN GMS restriction
mount -o ro,bind $MODDIR/xml/permissions/oplus.feature.control_cn_gms.xml /mnt/vendor/my_bigball/etc/permissions/oplus.feature.control_cn_gms.xml
mount -o ro,bind $MODDIR/xml/permissions/oplusfeature.region_cn.com.oplus.battery.xml /mnt/vendor/my_bigball/etc/permissions/oplusfeature.region_cn.com.oplus.battery.xml

#mount -o ro,bind $MODDIR/xml/permissions/feature_com.android.phone.xml /mnt/vendor/my_region/etc/extension/feature_com.android.phone.xml

# Unlock engineermode
ENG_XML="engineer_order_list.xml"
if [ -e "/system/system_ext/etc/engineermode/${ENG_XML}" ]; then
    cp -a /system/system_ext/etc/engineermode/${ENG_XML} ${MODDIR}/xml/${ENG_XML}
    sed -i 's@level="[0-9]"@level="1"@g' ${MODDIR}/xml/${ENG_XML}
    mount -o ro,bind ${MODDIR}/xml/${ENG_XML} /system/system_ext/etc/engineermode/${ENG_XML}
fi

# Google Lens
mount -o ro,bind $MODDIR/xml/permissions/oplus_google_lens_config.xml /mnt/vendor/my_bigball/etc/permissions/oplus_google_lens_config.xml

# Enable global features
if [ -e "${MODDIR}/xml/com.oppo.features_allnet_android.xml" ]; then
    mount -o ro,bind ${MODDIR}/xml/com.oppo.features_allnet_android.xml /my_product/etc/permissions/com.oppo.features_allnet_android.xml
fi

if [ -e "${MODDIR}/xml/my_heytap/permissions" ]; then
    mount -o ro,bind ${MODDIR}/xml/my_heytap/permissions/ /my_heytap/etc/permissions
fi

if [ -e "${MODDIR}/xml/my_heytap/app" ]; then
    mount -o ro,bind ${MODDIR}/xml/my_heytap/app/ /my_heytap/app
fi

if [ -e "${MODDIR}/xml/my_heytap/priv-app" ]; then
    mount -o ro,bind ${MODDIR}/xml/my_heytap/priv-app/ /my_heytap/priv-app
fi

mount -o ro,bind $MODDIR/xml/oplus_carrier_config.xml /my_region/etc/oplus_carrier_config.xml

# Google Dialer
if [ -d ${MODDIR}/xml/overlay/GmsConfigOverlayComms.apk ];then
    cp -a $MODDIR/xml/overlay/GmsConfigOverlayComms.apk $MODDIR/my_heytap/overlay/GmsConfigOverlayComms.apk
fi

if [ -e "${MODDIR}/xml/my_heytap/overlay" ]; then
    mount -o ro,bind ${MODDIR}/xml/my_heytap/overlay/ /my_heytap/overlay
fi
