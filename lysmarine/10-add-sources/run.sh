#!/bin/bash -e
if [ $LMBUILD == raspbian ] ;then
	apt-mark hold raspberrypi-sys-mods
fi

if [ $LMBUILD == armbian-pine64 ] ;then
	echo 'root:raspberry' | chpasswd
fi



apt-get update  -y -q
apt-get install -y -q apt-transport-https lsb-release wget gnupg



DISTRO="$(lsb_release -s -c)"

## Nodejs10
wget wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add
echo "deb https://deb.nodesource.com/node_10.x $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list

## Opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220
echo "deb http://ppa.launchpad.net/opencpn/opencpn/ubuntu/ eoan main" > /etc/apt/sources.list.d/opencpnsource.list
install -m0644 -v $FILE_FOLDER/50-lysmarine "/etc/apt/preferences.d/"

## XyGrib
wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key  | apt-key add -
echo "deb https://www.free-x.de/debian/ $DISTRO main contrib non-free" > /etc/apt/sources.list.d/oss.list

## Upadate
apt-get update  -y -q
apt-get upgrade -y -q
