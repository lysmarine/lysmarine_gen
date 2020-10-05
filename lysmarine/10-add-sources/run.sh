#!/bin/bash -e

apt-get update  -y -q
apt-get upgrade -y -q
apt-get install -y -q apt-transport-https lsb-release wget gnupg dirmngr

## Nodejs
wget wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add
echo "deb https://deb.nodesource.com/node_10.x buster main" | tee /etc/apt/sources.list.d/nodesource.list

## Opencpn  
#opencpn's PPA does not provide arm64 binaries, but the multiarch packages are still useful.
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220
echo "deb http://ppa.launchpad.net/opencpn/opencpn/ubuntu bionic main" > /etc/apt/sources.list.d/opencpn.list
install -m0644 -v $FILE_FOLDER/50-lysmarine "/etc/apt/preferences.d/" # Prefer opencpn's PPA to free-x

## XyGrib
wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key  | apt-key add -
echo "deb https://www.free-x.de/debian/ buster main contrib non-free" > /etc/apt/sources.list.d/xygrib.list


## Update
apt-get update  -y -q