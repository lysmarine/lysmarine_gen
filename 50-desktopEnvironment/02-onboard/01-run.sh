#!/bin/bash -e

install -d "${ROOTFS_DIR}/usr/share/onboard/"
install -v files/onboard.dconf "${ROOTFS_DIR}/usr/share/onboard/"

on_chroot << EOF
  echo "dconf load /org/onboard/ < /usr/share/onboard/onboard.dconf &" >> /home/pi/.config/openbox/autostart
EOF
