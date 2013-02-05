[ "$FREETZ_REMOVE_WLAN" == "y" ] || return 0

echo1 "removing WLAN files"
rm_files $(find ${FILESYSTEM_MOD_DIR}/lib/modules -name '*wireless*')
rm_files $(find ${FILESYSTEM_MOD_DIR} ! -name '*.cfg' -a -name '*wlan*' | grep -Ev '^${FILESYSTEM_MOD_DIR}/(dev|oldroot|proc|sys|var)/')
rm_files ${FILESYSTEM_MOD_DIR}/lib/modules/fw_dcrhp_1150_ap.bin \
	${FILESYSTEM_MOD_DIR}/sbin/hostapd \
	${FILESYSTEM_MOD_DIR}/sbin/wstart \
	${FILESYSTEM_MOD_DIR}/sbin/wpa_supplicant \
	${FILESYSTEM_MOD_DIR}/usr/bin/wpa_authenticator \
	${FILESYSTEM_MOD_DIR}/sbin/avmstickandsurf \
	${FILESYSTEM_MOD_DIR}/usr/bin/iwpriv \
	${FILESYSTEM_MOD_DIR}/usr/bin/iwconfig \
	${FILESYSTEM_MOD_DIR}/usr/share/ctlmgr/libwlan.so

menu2html_remove wlan

sedfile="${HTML_LANG_MOD_DIR}/internet/internet_settings.lua"
if [ -e $sedfile ]; then
	# patcht Internet > Zugangsdaten > Internetzugang
	echo1 "patching ${sedfile##*/}"
	modsed '/^require"wlanscan"$/d' $sedfile
	modsed '/^wlanscanOnload.*$/d' $sedfile
fi

sedfile="${HTML_LANG_MOD_DIR}/net/network_user_devices.lua"
if [ -e $sedfile ]; then
	# patcht Heimetz > Netzwerk > Geräte und Benutzer
	echo1 "patching ${sedfile##*/}"
	modsed 's/&& <?lua box.js(tostring(g_dev.wlan_count<2)) ?>//g' $sedfile
fi

echo1 "patching rc.conf"
modsed "s/CONFIG_WLAN=.*$/CONFIG_WLAN=\"n\"/g" "${FILESYSTEM_MOD_DIR}/etc/init.d/rc.conf"
