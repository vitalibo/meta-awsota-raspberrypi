FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
  file://wpa_supplicant-wlan0.conf \
"

FILES_${PN}_append = " \
  ${sysconfdir}/wpa_supplicant/wpa_supplicant-wlan0.conf \
"

WIFI_SSID ?= "ssid"
WIFI_PASSKEY ?= "password"

do_install_append() {
  install -d ${D}${sysconfdir}/wpa_supplicant
  sed -i -e 's#[@]WIFI_PASSKEY[@]#${WIFI_PASSKEY}#' ${WORKDIR}/wpa_supplicant-wlan0.conf
  sed -i -e 's#[@]WIFI_SSID[@]#${WIFI_SSID}#' ${WORKDIR}/wpa_supplicant-wlan0.conf

  install -m 0755 ${WORKDIR}/wpa_supplicant-wlan0.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-nl80211-wlan0.conf

  # Make sure the system directory for systemd exists.
  install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/

  # Link the service file for autostart.
  ln -s ${systemd_unitdir}/system/wpa_supplicant-nl80211@.service \
  ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant-nl80211@wlan0.service
}
