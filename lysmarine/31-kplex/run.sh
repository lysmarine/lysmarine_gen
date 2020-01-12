#!/bin/bash -e
apt-get install -y -q  libc6

install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/.kplex.conf "/home/user/.kplex.conf"

wget http://www.stripydog.com/download/kplex_1.4-1_armhf.deb
dpkg -i kplex_1.4-1_armhf.deb
rm kplex_1.4-1_armhf.deb

systemctl enable kplex
