#!/bin/bash -e

on_chroot << EOF
   echo " - Install speedsample"
   cd /opt/
   git clone https://gitlab.com/FredericGuilbault/speedSample
   cd speedSample;
   npm install --unsafe-perm ;
   cd /
EOF

install -m 644 -v files/speedsample.service  "${ROOTFS_DIR}/etc/systemd/system/speedsample.service"
ln -sf "${ROOTFS_DIR}/etc/systemd/system/speedsample.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/speedsample.service"
