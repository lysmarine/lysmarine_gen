#!/bin/bash -e
install  -d -o 1000 -g 1000 -m 755 -d "${ROOTFS_DIR}/home/pi/.themes"
install  -d -o 1000 -g 1000 -m 755 -d "${ROOTFS_DIR}/home/pi/.icons"

on_chroot << EOF
rm -rf openbox-theme-collections
rm -rf flat-remix
rm -rf gtk-theme-collections
git clone -q https://github.com/addy-dclxvi/openbox-theme-collections
git clone -q https://github.com/daniruiz/flat-remix
git clone -q https://github.com/addy-dclxvi/gtk-theme-collections

cp -r ./openbox-theme-collections/Numix-Clone /home/pi/.themes/
chown -R pi:pi /home/pi/.themes/Numix-Clone
cp -r flat-remix/Flat-Remix-Dark /home/pi/.icons/
chown -R pi:pi /home/pi/.icons/Flat-Remix-Dark
cp -r ./gtk-theme-collections/Noita /home/pi/.themes/
chown -R pi:pi /home/pi/.themes/Noita

rm -rf openbox-theme-collections
rm -rf flat-remix
rm -rf gtk-theme-collections
EOF



install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.config/"
install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.config/feh/"
install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.config/gtk-3.0/"
install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.config/openbox/"
install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.config/terminator/"
install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.config/tint2/"
install -o 1000 -g 1000  -v files/.gtkrc-2.0    "${ROOTFS_DIR}/home/pi/"
install -o 1000 -g 1000  -v files/deep-blue.jpg "${ROOTFS_DIR}/home/pi/.config/feh/"
install -o 1000 -g 1000  -v files/settings.ini  "${ROOTFS_DIR}/home/pi/.config/gtk-3.0/"
install -o 1000 -g 1000  -v files/autostart     "${ROOTFS_DIR}/home/pi/.config/openbox/"
install -o 1000 -g 1000  -v files/rc.xml        "${ROOTFS_DIR}/home/pi/.config/openbox/"
install -o 1000 -g 1000  -v files/tint2rc       "${ROOTFS_DIR}/home/pi/.config/tint2/"
