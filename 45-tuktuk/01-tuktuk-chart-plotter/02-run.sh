#!/bin/bash -e

on_chroot << EOF
   echo " - Install tuktuk"
   cd /opt/
   git clone https://gitlab.com/FredericGuilbault/tuktuk-chart-plotter
   cd tuktuk-chart-plotter
   pwd
   git checkout lysmarine/master

   npm install --unsafe-perm --cache /tmp/empty-cache;
   echo " -package Install done"

   NODE_ENV=production npm run bundle:js
   NODE_ENV=production npm run bundle:css
   echo " - Bundle done"

   cd /
   echo " It's Done for tuktuk"
EOF

install files/client-config.json "${ROOTFS_DIR}/opt/tuktuk-chart-plotter/client-config.json"

install -m 644 -v files/tuktuk.service  "${ROOTFS_DIR}/etc/systemd/system/tuktuk.service"
ln -sf "${ROOTFS_DIR}/etc/systemd/system/tuktuk.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/tuktuk.service"
