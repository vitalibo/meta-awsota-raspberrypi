do_install_append() {
  rm -rf ${D}/${BPN}/certs
  ln -sf ${EFI_PREFIX}/${BPN}/certs/ ${D}/${BPN}/
  rm -rf ${D}/${BPN}/config
  ln -sf ${EFI_PREFIX}/${BPN}/config/ ${D}/${BPN}/
}

CONFFILES_${PN}_remove += "/${BPN}/config/config.json"
