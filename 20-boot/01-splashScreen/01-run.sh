#!/bin/bash -e

cat  files/appendToConfig.txt >> "${ROOTFS_DIR}/boot/config.txt"

install -v -m0755 files/showLysmarineLogo.sh "${ROOTFS_DIR}/bin/splashScreen"
install -v files/ascii_logo.txt "${ROOTFS_DIR}/etc/motd"
install -v files/splash.png "${ROOTFS_DIR}/usr/share/splash.png"
install -v files/splashscreen.service "${ROOTFS_DIR}/etc/systemd/system/splashscreen.service"

on_chroot << EOF
   apt-get remove -y plymouth
   systemctl enable splashscreen.service
EOF
