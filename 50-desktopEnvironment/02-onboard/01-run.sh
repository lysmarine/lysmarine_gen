#!/bin/bash -e

install -d "${ROOTFS_DIR}/usr/share/onboard/"
install -v files/onboard.dconf "${ROOTFS_DIR}/usr/share/onboard/"
install -v files/a11y.dconf "${ROOTFS_DIR}/usr/share/onboard/"

on_chroot << EOF
  echo "sleep 1 ; dconf load /org/onboard/ < /usr/share/onboard/onboard.dconf &" >> /home/pi/.config/openbox/autostart
  echo "sleep 1 ; dconf load / < /usr/share/onboard/a11y.dconf &" >> /home/pi/.config/openbox/autostart

EOF
