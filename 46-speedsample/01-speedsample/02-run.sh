#!/bin/bash -e

on_chroot << EOF
   echo " - Install speedsample"
   cd /opt/
   git clone https://gitlab.com/FredericGuilbault/speedSample
   cd speedSample;
   npm install -g --unsafe-perm --loglevel error;
   cd /
EOF

install -m 644 -v files/speedsample.service  "${ROOTFS_DIR}/etc/systemd/system/speedsample.service"
#ln -sf "${ROOTFS_DIR}/etc/systemd/system/speedsample.service" "${ROOTFS_DIR}/etc/systemd/system/graphical.target.wants/speedsample.service"
on_chroot << EOF
  systemctl enable speedsample.service
EOF
