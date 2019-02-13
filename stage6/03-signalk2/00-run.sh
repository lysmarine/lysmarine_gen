#!/bin/bash -e

on_chroot << EOF
  cd /home/pi/.config/
  git clone https://github.com/SignalK/signalk-server-node.git
  cd signalk-server-node
  npm install --unsafe-perm

  cd ..
  chown -R pi:pi signalk-server-node

EOF

install -o 1000 -g 1000 files/security.json "${ROOTFS_DIR}/home/pi/.signalk/security.json"
