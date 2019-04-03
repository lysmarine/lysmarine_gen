#!/bin/bash -e
on_chroot <<EOF

EOF
install files/x11vnc.service "${ROOTFS_DIR}/etc/systemd/system/x11vnc.service"
