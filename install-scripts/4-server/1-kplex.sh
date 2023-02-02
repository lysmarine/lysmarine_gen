#!/bin/bash -e
apt-get install -y -q libc6

## Detect the right package to download.
if [[ $LMARCH == 'arm64' ]]; then
	apt-get install -yq gcc-10-base:armhf libc6:armhf libgcc1:armhf
	package='kplex_1.4-1_armhf.deb'
else
	package="kplex_1.4-1_${LMARCH}.deb"
fi

## Download and install the package.
wget http://www.stripydog.com/download/$package
dpkg -i $package
rm $package
