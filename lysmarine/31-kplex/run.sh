#!/bin/bash -e
apt-get install -y -q libc6

install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/.kplex.conf "/home/user/.kplex.conf"

if [ $LMBUILD == debian-amd64 ] || [ $LMBUILD == debian-vbox ] ;then
	wget http://www.stripydog.com/download/kplex_1.4-1_amd64.deb
	dpkg -i kplex_1.4-1_amd64.deb
	rm kplex_1.4-1_amd64.deb

else
	apt-get install -y -q gcc-8-base:armhf libc6:armhf libgcc1:armhf # Force the arch to prevent arm64 packages on raspbian.
	wget http://www.stripydog.com/download/kplex_1.4-1_armhf.deb
	dpkg -i kplex_1.4-1_armhf.deb
	rm kplex_1.4-1_armhf.deb

fi

systemctl enable kplex
