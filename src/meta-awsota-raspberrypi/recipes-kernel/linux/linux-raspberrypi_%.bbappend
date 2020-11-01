FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " file://linux-kernel.cfg "
KERNEL_CONFIG_FRAGMENTS_append = "${WORKDIR}/linux-kernel.cfg "

CGROUP_MEMORY = "${@bb.utils.contains("IMAGE_INSTALL", "greengrass", "cgroup_enable=memory cgroup_memory=1", "",d)}"
CMDLINE += " ${CGROUP_MEMORY}"
