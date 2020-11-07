SUMMARY = "AWS IoT Job agent with Mender integration demo"
DESCRIPTION = " \
  This demo show show to integrate AWS IoT Device Management Jobs with the mender \
  client in order to perform safe system OTA upgrades. \
"
HOMEPAGE = "https://github.com/aws-samples/aws-iot-jobs-full-system-update"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=34400b68072d710fecd0a2940a0d1658"

SRC_URI = " \
  git://github.com/aws-samples/aws-iot-jobs-full-system-update.git;tag=v${PV} \
  file://AmazonRootCA1.pem \
  file://goagent.conf \
  file://goagent.service \
"

inherit go goarch
inherit systemd

SYSTEMD_SERVICE_${PN} = "goagent.service"

GO_IMPORT = "github.com/aws-samples/aws-iot-jobs-full-system-update"

do_configure_append() {
  if [ -z "${AWS_IOT_ENDPOINT}" ]; then
    bberror "Need to define AWS_IOT_ENDPOINT variable."
    exit 1
  fi

  sed -i -e 's#[@]AWS_IOT_ENDPOINT[@]#${AWS_IOT_ENDPOINT}#' ${WORKDIR}/goagent.conf
}

do_compile() {
  cd src/${GO_IMPORT}/files
  go build ../goagent.go
  go clean -modcache
}

do_install() {
  install -d ${D}${bindir}
  install -m 755 -D ${S}/src/${GO_IMPORT}/files/goagent ${D}${bindir}

  install -d ${D}${sysconfdir}/goagent
  install -m 644 -D ${WORKDIR}/goagent.conf ${D}${sysconfdir}/goagent/goagent.conf
  install -m 444 -D ${WORKDIR}/AmazonRootCA1.pem ${D}${sysconfdir}/goagent/rootCA.pem
  install -d ${D}${systemd_unitdir}/system
  install -m 644 ${WORKDIR}/goagent.service ${D}${systemd_unitdir}/system
}

FILES_${PN} = " \
  ${bindir} \
  ${sysconfdir}/goagent \
"

RDEPENDS_${PN} += " \
  mender-client \
"
