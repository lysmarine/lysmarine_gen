#!/bin/bash -e
install -m 755 -o 1000 -g 1000   files/kplex.conf "${ROOTFS_DIR}/home/pi/.kplex.conf"
on_chroot << EOF
wget http://www.stripydog.com/download/kplex_1.4-1_armhf.deb
dpkg -i kplex_1.4-1_armhf.deb
rm kplex_1.4-1_armhf.deb
EOF
