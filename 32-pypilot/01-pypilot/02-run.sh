#!/bin/bash -e

install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.pypilot"
install -v -o 1000 -g 1000 files/signalk.conf "${ROOTFS_DIR}/home/pi/.pypilot/"

install files/pypilot.desktop "${ROOTFS_DIR}/usr/share/applications/"
install files/pypilot_webapp.desktop "${ROOTFS_DIR}/usr/share/applications/"
on_chroot << EOF
  pip install pyglet ujson PyOpenGL PyWavefront flask_socketio
EOF

on_chroot << EOF

  echo " RTIMULib2 : "
  git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
  cd RTIMULib2/Linux/python
  python setup.py install

  cd ../../
  rm -rf /RTIMULib2

  echo " Pypilot : "
  cd /
  git clone --depth=1 https://github.com/pypilot/pypilot.git
  git clone --depth=1 https://github.com/pypilot/pypilot_data.git
  cp -rv pypilot_data/* pypilot
  rm -rf pypilot_data

  cd pypilot
  python setup.py build
  python setup.py install
  cd scripts/debian/
  cp -r etc/systemd/system/* /etc/systemd/system/
  cd /
  rm -rf pypilot

EOF
