#!/bin/bash -e

on_chroot << EOF
npm install --loglevel error -g --unsafe-perm signalk-server
EOF

install -d "${ROOTFS_DIR}/home/pi/.signalk"
install -m 644 -o 1000 -g 1000  -v files/defaults.json  "${ROOTFS_DIR}/home/pi/.signalk/defaults.json"
install -m 644 -o 1000 -g 1000  -v files/package.json   "${ROOTFS_DIR}/home/pi/.signalk/package.json"
install -m 644 -o 1000 -g 1000  -v files/settings.json  "${ROOTFS_DIR}/home/pi/.signalk/settings.json"
install -m 755 -o 1000 -g 1000  -v files/signalk-server "${ROOTFS_DIR}/home/pi/.signalk/signalk-server"

install -m 644 -v files/signalk.service "${ROOTFS_DIR}/etc/systemd/system/signalk.service"
install -m 644 -v files/signalk.socket  "${ROOTFS_DIR}/etc/systemd/system/signalk.socket"

ln -sf "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/signalk.service" "${ROOTFS_DIR}/etc/systemd/system/signalk.service"
ln -sf "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/signalk.socket" "${ROOTFS_DIR}/etc/systemd/system/signalk.socket"
