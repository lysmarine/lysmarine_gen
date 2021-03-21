#!/bin/bash -e

apt-get install -y -q  wget gnupg

## Add the extended sources software source for Debian
sed -i "s/deb\.debian\.org\/debian\/\ buster\ main/deb\.debian\.org\/debian\/\ buster\ main\ contrib\ non-free/g" /etc/apt/sources.list

## Add repository sources
install -m0644 -v $FILE_FOLDER/nodesource.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/opencpn.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/xygrib.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/lysmarine.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/evdev-rce.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/mopidy.list "/etc/apt/sources.list.d/"

## Prefer opencpn PPA to free-x (for mainly for the opencpn package)
install -m0644 -v $FILE_FOLDER/50-lysmarine.pref "/etc/apt/preferences.d/"

## Get the signatures
gpg --keyserver keyserver.ubuntu.com --recv-key 67E4A52AC865EB40
gpg -a --export 67E4A52AC865EB40 | apt-key add - &
gpg --keyserver keyserver.ubuntu.com --recv-key 6AF0E1940624A220
gpg -a --export 6AF0E1940624A220 | apt-key add - &
gpg --keyserver keyserver.ubuntu.com --recv-key 868273edce9979e7
gpg -a --export 868273edce9979e7 | apt-key add - &
gpg --keyserver keyserver.ubuntu.com --recv-key 24A4598E769C8C51
gpg -a --export 24A4598E769C8C51 | apt-key add - &
wget -q -O- https://apt.mopidy.com/mopidy.gpg | apt-key add - & # Mopidy
wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - & # NodeJs
wget -q -O- https://www.free-x.de/debian/oss.boating.gpg.key | apt-key add - & # XyGrib

wait

## Update && Upgrade
apt-get update  -yq || true
apt-get upgrade -yq || true
gpgconf --kill gpg-agent
gpgconf --kill dirmngr
## Block vscode addition
DEBIAN_FRONTEND=noninteractive apt-get install -yq -o Dpkg::Options::="--force-confnew" block-vscode-repository || true