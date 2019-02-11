#!/bin/bash -e
install -m 755 -o 1000 -g 1000  -d "${ROOTFS_DIR}/home/pi/.signalk"
install -m 644 -o 1000 -g 1000   files/defaults.json  "${ROOTFS_DIR}/home/pi/.signalk/defaults.json"
install -m 644 -o 1000 -g 1000   files/package.json   "${ROOTFS_DIR}/home/pi/.signalk/package.json"
install -m 644 -o 1000 -g 1000   files/settings.json  "${ROOTFS_DIR}/home/pi/.signalk/settings.json"
install -m 755 -o 1000 -g 1000   files/signalk-server "${ROOTFS_DIR}/home/pi/.signalk/signalk-server"
on_chroot << EOF
npm install --loglevel error -g --unsafe-perm signalk-server
EOF


install -m 644 -v files/signalk.service "${ROOTFS_DIR}/etc/systemd/system/signalk.service"
install -m 644 -v files/signalk.socket  "${ROOTFS_DIR}/etc/systemd/system/signalk.socket"

ln -sf "${ROOTFS_DIR}/etc/systemd/system/signalk.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/signalk.service"
ln -sf "${ROOTFS_DIR}/etc/systemd/system/signalk.socket"  "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/signalk.socket"
