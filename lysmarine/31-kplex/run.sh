#!/bin/bash -e

install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/.kplex.conf "/home/pi/.kplex.conf"

wget http://www.stripydog.com/download/kplex_1.4-1_armhf.deb
dpkg -i kplex_1.4-1_armhf.deb
rm kplex_1.4-1_armhf.deb

systemctl enable kplex
