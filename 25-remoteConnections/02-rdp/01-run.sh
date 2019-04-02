#!/bin/bash -e

install files/Xwrapper.config "${ROOTFS_DIR}/etc/X11/Xwrapper.config"

on_chroot <<EOF
# systemctl disable xrdp.service
# systemctl disable xrdp-sesman.service

EOF
