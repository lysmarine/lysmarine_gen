#!/bin/bash -e
install -d "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d"
install files/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d"
install -o 1000 -g 1000 files/profile "${ROOTFS_DIR}/home/pi/.profile"
install files/x11vnc.service "${ROOTFS_DIR}/etc/systemd/system/x11vnc.service"

on_chroot << EOF
systemctl enable getty@tty1.service
EOF
