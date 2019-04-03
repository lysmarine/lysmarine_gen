#!/bin/bash -e
install -d  "${ROOTFS_DIR}/opt/openplotter/"

on_chroot << EOF
  pip install setuptools
  pip install requests ujson websocket websocket-client paho-mqtt geomag     pyudev serial smbus      websocket websocket-client python-can    pynmea2
EOF

on_chroot << EOF
  cd /opt/
  git clone https://gitlab.com/FredericGuilbault/openplotter.git
  cd openplotter
  git checkout  lysmarine_flavor

  wget http://www.fars-robotics.net/install-wifi -O /usr/bin/install-wifi
  chmod +x /usr/bin/install-wifi
EOF

install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.local/share/applications/"
install -o 1000 -g 1000 files/openplotter.desktop "${ROOTFS_DIR}/home/pi/.local/share/applications/"
