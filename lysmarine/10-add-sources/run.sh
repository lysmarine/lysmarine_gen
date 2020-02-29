#!/bin/bash -e

## Raspbian
if [[ $LMOS == 'Raspbian' ]]; then
	echo 'Set Raspbian repositories';
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50 112695A0E562B32A 82B129927FA3303E
	echo "deb http://archive.raspberrypi.org/debian/ buster main" > /etc/apt/sources.list.d/raspi.list
	echo "deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi" > /etc/apt/sources.list

elif [[ $LMOS == 'Debian' ]]; then 
	echo 'Set Debian repositories';
	echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list
	echo "deb http://deb.debian.org/debian buster-updates main contrib non-free" >> /etc/apt/sources.list
	echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list

fi



apt-get update  -y -q
apt-get install -y -q apt-transport-https gnupg     lsb-release wget # maybe armbian ?



## Nodejs
wget wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add
echo "deb https://deb.nodesource.com/node_10.x buster main" | tee /etc/apt/sources.list.d/nodesource.list



## Opencpn  
#opencpn's PPA does not provide arm64 binaries, but the multiarch packages are still usefull.
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220
echo "deb http://ppa.launchpad.net/opencpn/opencpn/ubuntu/ eoan main" > /etc/apt/sources.list.d/opencpnsource.list
install -m0644 -v $FILE_FOLDER/50-lysmarine "/etc/apt/preferences.d/" # make opencpn's PPA prefered to free-x



## XyGrib
wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key  | apt-key add -
echo "deb https://www.free-x.de/debian/ buster main contrib non-free" > /etc/apt/sources.list.d/oss.list



## Upadate
apt-get update -y -q