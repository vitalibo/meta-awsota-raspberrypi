FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
  file://eth.network \
  file://en.network \
  file://wireless.network \
"

FILES_${PN}_append = " \
  ${sysconfdir}/systemd/network/eth.network \
  ${sysconfdir}/systemd/network/en.network \
  ${sysconfdir}/systemd/network/wireless.network \
"

do_install_append() {
  install -d ${D}${sysconfdir}/systemd/network
  install -m 0755 ${WORKDIR}/eth.network ${D}${sysconfdir}/systemd/network
  install -m 0755 ${WORKDIR}/en.network ${D}${sysconfdir}/systemd/network
  install -m 0755 ${WORKDIR}/wireless.network ${D}${sysconfdir}/systemd/network
}
