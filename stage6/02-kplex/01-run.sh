#!/bin/bash -e

on_chroot << EOF
wget http://www.stripydog.com/download/kplex_1.4-1_armhf.deb
dpkg -i kplex_1.4-1_armhf.deb
touch /home/pi/.kplex.conf
EOF
