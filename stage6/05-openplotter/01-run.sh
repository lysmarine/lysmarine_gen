#!/bin/bash -e
install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.config/openplotter"
on_chroot << EOF
git clone https://github.com/sailoog/openplotter.git
cd openplotter
git checkout 4845ae7faf8b38324f104eced9068eaadfb851fa ; # The v1.2.0 commit. ;

cp -r ./*  /home/pi/.config/openplotter/
chown -R pi:pi /home/pi/.config/openplotter
cd ..
rm -rf openplotter

EOF
install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.local/share/applications/openplotter/"
install -o 1000 -g 1000 files/openplotter.desktop "${ROOTFS_DIR}/home/pi/.local/share/applications/"
