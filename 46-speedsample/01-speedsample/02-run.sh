#!/bin/bash -e

on_chroot << EOF
   echo " - Install speedsample"
   cd /var/www/
   git clone --depth=1 https://gitlab.com/FredericGuilbault/speedSample
   cd speedSample;
   npm install -g --unsafe-perm --loglevel error;
   cd /
EOF

install -m 644 -v files/speedsample.service  "${ROOTFS_DIR}/etc/systemd/system/speedsample.service"

on_chroot << EOF
  chown -R www-data:www-data /var/www/speedSample

  systemctl enable speedsample.service
EOF
