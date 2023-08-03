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
mount -o ro,bind $MODDIR/xml/permissions/oplus.feature.control_cn_gms.xml /mnt/vendor/my_bigball/etc/permissions/oplus.feature.control_cn_gms.xml
# mount -o ro,bind $MODDIR/xml/permissions/oplus_google_cn_gms_features.xml /mnt/vendor/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
mount -o ro,bind $MODDIR/xml/permissions/oplusfeature.region_cn.com.oplus.battery.xml /mnt/vendor/my_bigball/etc/permissions/oplusfeature.region_cn.com.oplus.battery.xml

mount -o ro,bind $MODDIR/xml/permissions/feature_com.android.phone.xml /mnt/vendor/my_region/etc/extension/feature_com.android.phone.xml

# Delete region lock config
mount -o ro,bind $MODDIR/xml/regionlock_config.xml /mnt/vendor/my_bigball/etc/regionlock_config.xml
mount -o ro,bind $MODDIR/xml/regionlock_config.xml /mnt/vendor/my_product/etc/regionlock_config.xml
mount -o ro,bind $MODDIR/xml/regionlock_config.xml /mnt/vendor/my_region/etc/regionlock_config.xml

# mount -o ro,bind $MODDIR/xml/netcode_config.xml /system/system_ext/etc/netcode_config.xml
# mount -o ro,bind $MODDIR/xml/netcode_version.xml /system/system_ext/etc/netcode_version.xml

# Enable MEMC for Genshin
MEMC_XML="multimedia_pixelworks_game_apps.xml"
if [ -e "${MODDIR}/xml/${MEMC_XML}" ]; then
    mount -o ro,bind ${MODDIR}/xml/${MEMC_XML} /my_product/vendor/etc/${MEMC_XML}
fi
mount -o ro,bind $MODDIR/xml/multimedia_pixelworks_apps.xml /my_product/vendor/etc/multimedia_pixelworks_apps.xml
#mount -o ro,bind $MODDIR/xml/permissions/oplus.product.feature_video_motionf.xml /my_product/etc/permissions/oplus.product.feature_video_motionf.xml

DISP_XML="multimedia_display_feature_config.xml"
if [ -e "${MODDIR}/xml/$DISP_XML" ]; then
    mount -o ro,bind ${MODDIR}/xml/$DISP_XML /my_product/vendor/etc/$DISP_XML
fi

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
mount -o ro,bind $MODDIR/xml/permissions/com.oppo.features_expCommon.xml /my_product/etc/permissions/com.oppo.features_expCommon.xml
mount -o ro,bind $MODDIR/xml/permissions/oneplus-features.xml /system/system_ext/etc/permissions/oneplus-features.xml

mount -o ro,bind $MODDIR/xml/permissions/privapp-permissions-google-comms-suite.xml /my_heytap/etc/permissions/privapp-permissions-google-comms-suite.xml
mount -o ro,bind $MODDIR/xml/permissions/privapp-permissions-google-product.xml /my_heytap/etc/permissions/privapp-permissions-google-product.xml
mount -o ro,bind $MODDIR/xml/permissions/privapp-permissions-google-system.xml /my_heytap/etc/permissions/privapp-permissions-google-system.xml
mount -o ro,bind $MODDIR/xml/permissions/privapp-permissions-google-system-ext.xml /my_heytap/etc/permissions/privapp-permissions-google-system-ext.xml

mount -o ro,bind $MODDIR/xml/GoogleServicesFramework /my_heytap/priv-app/GoogleServicesFramework
mount -o ro,bind $MODDIR/xml/GoogleLocationHistory /my_heytap/app/GoogleLocationHistory

mount -o ro,bind $MODDIR/xml/oplus_carrier_config.xml /my_region/etc/oplus_carrier_config.xml

mount -o ro,bind $MODDIR/xml/overlay/GmsConfigOverlayASI.apk /my_heytap/overlay/GmsConfigOverlayASI.apk
mount -o ro,bind $MODDIR/xml/overlay/GmsConfigOverlayCommonExport.apk /my_heytap/overlay/GmsConfigOverlayCommonExport.apk
mount -o ro,bind $MODDIR/xml/overlay/OplusGmsConfigOverlayCommon.apk /my_heytap/overlay/OplusGmsConfigOverlayCommon.apk

# Google Dialer
if [ -d ${MODDIR}/xml/overlay/GmsConfigOverlayComms.apk ];then
mount -o ro,bind $MODDIR/xml/overlay/GmsConfigOverlayComms.apk /my_heytap/overlay/GmsConfigOverlayComms.apk
fi

resetprop -n ro.oplus.radio.global_regionlock.enabled false
resetprop -n persist.sys.radio.global_regionlock.allcheck false
resetprop -n persist.sys.oplus.radio.globalregionlock 0,0
resetprop -n persist.sys.oplus.radio.haslimited false
resetprop -n ro.oplus.radio.checkservice false
resetprop -n persist.sys.oplus.bnoticetimes -200000
resetprop -n persist.sys.oplus.pnoticetimes -200000
resetprop -n gsm.sim.oplus.radio.fnoticetime -200000