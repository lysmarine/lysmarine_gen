#!/bin/bash -e

on_chroot << EOF

   echo " - Install tuktuk"
   mkdir /var/www
   chown www-data:www-data /var/www
   cd /var/www
   git clone --depth=1 https://gitlab.com/FredericGuilbault/tuktuk-chart-plotter
   cd tuktuk-chart-plotter
   git checkout lysmarine/master

   npm install -g --unsafe-perm --loglevel error # --cache /tmp/empty-cache;
   echo " -package Install done"
   npm install --unsafe-perm webpack

   NODE_ENV=production npm run bundle:js
   NODE_ENV=production npm run bundle:css
   echo " - Bundle done"

   cd /
   echo " Compiling Done for tuktuk"
EOF

install files/client-config.json "${ROOTFS_DIR}/var/www/tuktuk-chart-plotter/client-config.json"
install -m 644 -v files/tuktuk.service  "${ROOTFS_DIR}/etc/systemd/system/tuktuk.service"

on_chroot << EOF
  systemctl enable tuktuk.service

  chown -R www-data:www-data /var/www/tuktuk-chart-plotter
  rm -rf /var/www/tuktuk-chart-plotter/charts
  ln -s  /srv/charts /var/www/tuktuk-chart-plotter/charts;
EOF
