#!/bin/bash -e
on_chroot << EOF
apt-get update -y
  adduser --home /home/signalk --uid 1001 --disabled-password --disabled-login signalk
EOF

install -m 755 -o 1001 -g 1001  -d "${ROOTFS_DIR}/home/signalk/.signalk"
install -m 644 -o 1001 -g 1001   files/defaults.json  "${ROOTFS_DIR}/home/signalk/.signalk/defaults.json"
install -m 644 -o 1001 -g 1001   files/package.json   "${ROOTFS_DIR}/home/signalk/.signalk/package.json"
install -m 644 -o 1001 -g 1001   files/settings.json  "${ROOTFS_DIR}/home/signalk/.signalk/settings.json"
install -m 755 -o 1001 -g 1001   files/signalk-server "${ROOTFS_DIR}/home/signalk/.signalk/signalk-server"
install -d -o 1000 -g 1000   "${ROOTFS_DIR}/home/pi/.local/share/icons/"

install -m 644 -o 1000 -g 1000   files/signalk.png "${ROOTFS_DIR}/home/pi/.local/share/icons/"

on_chroot << EOF
  npm install --loglevel error -g --unsafe-perm signalk-server
EOF

install -m 644 -v files/signalk.service "${ROOTFS_DIR}/etc/systemd/system/signalk.service"
install -m 644 -v files/signalk.socket  "${ROOTFS_DIR}/etc/systemd/system/signalk.socket"

ln -sf "${ROOTFS_DIR}/etc/systemd/system/signalk.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/signalk.service"
ln -sf "${ROOTFS_DIR}/etc/systemd/system/signalk.socket"  "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/signalk.socket"
