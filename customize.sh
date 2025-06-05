REPLACE="
"

# Taken from unlock-cn-gms
# Credit: Howard20181, yujincheng08 https://github.com/yujincheng08/unlock-cn-gms
# Function to find the first available XML permission file
find_origin() {
    for file in \
        /system/etc/permissions/services.cn.google.xml \
        /system/etc/permissions/com.oppo.features.cn_google.xml \
        /vendor/etc/permissions/services.cn.google.xml \
        /product/etc/permissions/services.cn.google.xml \
        /product/etc/permissions/cn.google.services.xml \
        /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml \
        /my_product/etc/permissions/oplus_google_cn_gms_features.xml \
        /my_heytap/etc/permissions/my_heytap_cn_gms_features.xml; do
        if [ -e "$file" ]; then
            echo "$file"
            return
        fi
    done
}

origin=$(find_origin)

if [[ $origin == *my_bigball* ]]; then
    target=$MODPATH/oplus_google_cn_gms_features.xml
    echo -e '#!/system/bin/sh\nmount -o ro,bind ${0%/*}/oplus_google_cn_gms_features.xml /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml' > $MODPATH/post-fs-data.sh
    # echo 'sleep 60; umount /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml' > $MODPATH/service.sh
elif [[ $origin == *my_product* ]]; then
    target=$MODPATH/oplus_google_cn_gms_features.xml
    echo -e '#!/system/bin/sh\nmount -o ro,bind ${0%/*}/oplus_google_cn_gms_features.xml /my_product/etc/permissions/oplus_google_cn_gms_features.xml' > $MODPATH/post-fs-data.sh
elif [[ $origin == *my_heytap* ]]; then
    target=$MODPATH/my_heytap_cn_gms_features.xml
    echo -e '#!/system/bin/sh\nmount -o ro,bind ${0%/*}/my_heytap_cn_gms_features.xml /my_heytap/etc/permissions/my_heytap_cn_gms_features.xml' > $MODPATH/post-fs-data.sh
    if [[ -e /my_heytap/etc/permissions/my_heytap_cn_features.xml ]]; then
        echo -e '\nmount -o ro,bind ${0%/*}/my_heytap_cn_features.xml /my_heytap/etc/permissions/my_heytap_cn_features.xml' >> $MODPATH/post-fs-data.sh
        heytap_cn_features_orgin=/my_heytap/etc/permissions/my_heytap_cn_features.xml
        heytap_cn_features_target=$MODPATH/my_heytap_cn_features.xml
    fi
elif [[ $origin == *system* ]]; then
    target=$MODPATH$origin    
else
    target=$MODPATH/system$origin
fi

mkdir -p $(dirname $target)
cp -f $origin $target
sed -i '/cn.google.services/d' $target
sed -i '/services_updater/d' $target
ui_print "modify $origin"

if [[ -e $heytap_cn_features_orgin ]]; then
mkdir -p $(dirname $heytap_cn_features_target)
cp -f $heytap_cn_features_orgin $heytap_cn_features_target
sed -i '/cn.google.services/d' $heytap_cn_features_target
sed -i '/services_updater/d' $heytap_cn_features_target
ui_print "modify $heytap_cn_features_orgin"
fi

DEF_DIALER=`cmd package resolve-activity --brief -a android.intent.action.DIAL | grep com.google.android.dialer`
if [ -n "$DEF_DIALER" ]; then
    cp -a ${MODPATH}/cn2g-optional/GmsConfigOverlayComms.apk ${MODPATH}/xml/overlay/GmsConfigOverlayComms.apk
    ui_print ""
    ui_print "******⚠注意⚠******"
    ui_print "Google 電話アプリを必ずデフォルトの電話アプリに"
    ui_print "設定して、権限や通知、自動起動を設定してください。"
    ui_print "設定していないと受話できなくなります。"
    ui_print "******⚠注意⚠******"
    ui_print ""
    ui_print ""
    ui_print "******⚠ WARNING ⚠******"
    ui_print "Please set Google Phone app as default-"
    ui_print "phone app and setup permissions / autostart."
    ui_print "If you don't, you can't receive a call."
    ui_print "******⚠ WARNING ⚠******"
    ui_print ""
fi

rm -rf ${MODPATH}/cn2g-optional

FEAT_XML="com.oppo.features_allnet_android.xml"
if [ -e /my_product/etc/permissions/${FEAT_XML} ]; then
    cp -a /my_product/etc/permissions/${FEAT_XML} ${MODPATH}/xml/${FEAT_XML}
    sed -i 's@</permissions>@<feature name="oppo.exp.default.browser" />\n<feature name="android.software.autofill" />\n</permissions>\n<feature name="com.oplus.assistantscreen.google_play_exp"/>\n<feature name="oppo.version.exp" />@g' ${MODPATH}/xml/${FEAT_XML}
fi

if [ -d /my_heytap/etc/permissions ]; then
    cp -ar /my_heytap/etc/permissions/. ${MODPATH}/xml/my_heytap/permissions/
    cp -a ${MODPATH}/xml/privapp-permissions-google-comms-suite.xml ${MODPATH}/xml/my_heytap/permissions/
    cp -a ${MODPATH}/xml/privapp-permissions-google-product.xml ${MODPATH}/xml/my_heytap/permissions/
    cp -a ${MODPATH}/xml/privapp-permissions-google-system.xml ${MODPATH}/xml/my_heytap/permissions/
    cp -a ${MODPATH}/xml/privapp-permissions-google-system-ext.xml ${MODPATH}/xml/my_heytap/permissions/
fi

if [ -d /my_heytap/overlay ]; then
    cp -ar /my_heytap/overlay/. ${MODPATH}/xml/my_heytap/overlay/
    cp -a ${MODPATH}/xml/overlay/GmsConfigOverlayASI_Features.apk ${MODPATH}/xml/my_heytap/overlay/
    cp -a ${MODPATH}/xml/overlay/GmsConfigOverlayCommonEx.apk ${MODPATH}/xml/my_heytap/overlay/
    cp -a ${MODPATH}/xml/overlay/GmsConfigOverlayGSA.apk ${MODPATH}/xml/my_heytap/overlay/
fi

if [ -d /my_heytap/app ]; then
    cp -ar /my_heytap/app/. ${MODPATH}/xml/my_heytap/app/
    cp -a ${MODPATH}/xml/GoogleLocationHistory ${MODPATH}/xml/my_heytap/app/
fi
