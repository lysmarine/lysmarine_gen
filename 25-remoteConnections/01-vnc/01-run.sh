#!/bin/bash -e
on_chroot <<EOF

EOF
install files/vnc.service "${ROOTFS_DIR}/etc/systemd/system/vnc.service"
