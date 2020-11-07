FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
  file://wireless.network \
"

FILES_${PN}_append = " \
  ${sysconfdir}/systemd/network/wireless.network \
"

do_install_append() {
  install -d ${D}${sysconfdir}/systemd/network
  install -m 0755 ${WORKDIR}/wireless.network ${D}${sysconfdir}/systemd/network
}
