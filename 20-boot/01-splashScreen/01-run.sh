#!/bin/bash -e

cat  files/appendToConfig.txt >> "${ROOTFS_DIR}/boot/config.txt"

cat  files/motd > "${ROOTFS_DIR}/etc/motd"

on_chroot << EOF
   apt-get remove -y plymouth
EOF
