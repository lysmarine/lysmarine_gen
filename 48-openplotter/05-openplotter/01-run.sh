#!/bin/bash -e
install -d  "${ROOTFS_DIR}/opt/openplotter/"

on_chroot << EOF
  pip install setuptools
  pip install requests ujson websocket websocket-client paho-mqtt geomag
EOF

on_chroot << EOF
cd /opt/
git clone https://github.com/sailoog/openplotter.git
cd openplotter
git checkout v2.x.x ; # We should use a fix commit hash to have reproductive builds

EOF

install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.local/share/applications/"
install -o 1000 -g 1000 files/openplotter.desktop "${ROOTFS_DIR}/home/pi/.local/share/applications/"
