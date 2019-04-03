#!/bin/bash -e

install    -o 1000 -g 1000 files/panelbg.png "${ROOTFS_DIR}/usr/share/panelbg.png"

install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.config/lxpanel/default/panels"
install    -o 1000 -g 1000 files/panel "${ROOTFS_DIR}/home/pi/.config/lxpanel/default/panels/panel"

install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.config/fbpanel"
install    -o 1000 -g 1000 files/default "${ROOTFS_DIR}/home/pi/.config/fbpanel/default"

install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.config/tint2/"
install    -o 1000 -g 1000  -v files/tint2rc       "${ROOTFS_DIR}/home/pi/.config/tint2/"



on_chroot << EOF
  echo '#lxpanel &' >> /home/pi/.config/openbox/autostart
  echo 'fbpanel &' >> /home/pi/.config/openbox/autostart
  echo '#tint2 &' >> /home/pi/.config/openbox/autostart
EOF


on_chroot << EOF
git clone https://github.com/FredericGuilbault/fbpanel

cd fbpanel
git checkout develop

./configure --prefix=/usr/
make
make install
cd /
rm -rf fbpanel
EOF
