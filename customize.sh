REPLACE="
"

DEF_DIALER=`cmd package resolve-activity --brief -a android.intent.action.DIAL | grep com.google.android.dialer`
if [ -n "$DEF_DIALER" ]; then
    cp -a ${MODPATH}/cn2g-optional/GmsConfigOverlayComms.apk ${MODPATH}/system/product/overlay
    ui_print ""
    ui_print "******⚠注意⚠******"
    ui_print "Google 電話アプリを必ずデフォルトの電話アプリに設定してください。"
    ui_print "設定していないと受話できなくなります。"
    ui_print "******⚠注意⚠******"
    ui_print ""
fi

rm -rf ${MODPATH}/cn2g-optional