#!/bin/bash -e
 install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.config/lxpanel/default/panels"
 install  -o 1000 -g 1000 files/panel "${ROOTFS_DIR}/home/pi/.config/lxpanel/default/panels/panel"
 install  -o 1000 -g 1000 files/panelbg.png "${ROOTFS_DIR}/usr/share/panelbg.png"

# on_chroot << EOF
# cpanm Linux::DesktopFiles Data::Dump
# #cpanm Linux::DesktopFiles Gtk2
# git clone -q git://github.com/trizen/obmenu-generator
#
# cp -vf obmenu-generator/obmenu-generator /usr/bin
# chmod -v a+x /usr/bin/obmenu-generator
# su pi -c '/usr/bin/obmenu-generator -i -p '
# rm -rv obmenu-generator
# EOF
#


#
# install -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/applications/"
# install -o 1000 -g 1000  -v files/open-openbox-menu.desktop    "${ROOTFS_DIR}/home/pi/.local/share/applications/"
#
# install -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/icons"
# install -o 1000 -g 1000  -v files/signalk.png    "${ROOTFS_DIR}/home/pi/.local/share/icons/"
