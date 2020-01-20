#!/bin/bash -e
apt-get install -y -q  libc6

install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/.kplex.conf "/home/user/.kplex.conf"

if [ $LMBUILD == debian-amd64 ] ;then
	wget http://www.stripydog.com/download/kplex_1.4-1_amd64.deb
	dpkg -i kplex_1.4-1_amd64.deb
	rm kplex_1.4-1_amd64.deb

elif [ $LMBUILD == raspbian ] ;then
	wget http://www.stripydog.com/download/kplex_1.4-1_armhf.deb
	dpkg -i kplex_1.4-1_armhf.deb
	rm kplex_1.4-1_armhf.deb

else
	wget http://www.stripydog.com/download/kplex-1.4.tgz
	tar zxf kplex-1.4.tgz
	pushd kplex-1.4
		make
		make install
	popd
	rm -r kplex-1.4.tgz
	rm -r kplex-1.4
fi


systemctl enable kplex
