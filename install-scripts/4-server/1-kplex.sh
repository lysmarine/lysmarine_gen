#!/bin/bash -e
apt-get install -y -q libc6

## Detect the right package to download.
	package='kplex_1.4-1_amd64.deb'
elif [[ $LMARCH == 'armhf' ]]; then
	package='kplex_1.4-1_armhf.deb'
elif [[ $LMARCH == 'arm64' ]]; then
	apt-get install -y -q gcc-8-base:armhf libc6:armhf libgcc1:armhf
	package='kplex_1.4-1_armhf.deb'
fi

## Download and install the package.
wget http://www.stripydog.com/download/$package
dpkg -i $package
rm $package

systemctl enable kplex