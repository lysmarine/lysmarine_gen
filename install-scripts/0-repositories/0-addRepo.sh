#!/bin/bash -e

apt-get install -y -q wget gnupg dirmngr

## Add the extended sources software source for Debian
sed -i "s/deb\.debian\.org\/debian\/\ bullseye\ main/deb\.debian\.org\/debian\/\ bullseye\ main\ contrib\ non-free/g" /etc/apt/sources.list

## Add repository sources
install -m0644 -v $FILE_FOLDER/nodesource.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/opencpn.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/xygrib.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/lysmarine.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/evdev-rce.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/mopidy.list "/etc/apt/sources.list.d/"

## Prefer opencpn's PPA to free-x
install -m0644 -v $FILE_FOLDER/50-lysmarine.pref "/etc/apt/preferences.d/"
install -m0644 -v $FILE_FOLDER/00-mobian.pref "/etc/apt/preferences.d/"

## Get the signatures
gpg --list-keys
gpg --no-default-keyring --keyring /usr/share/keyrings/opencpn-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 67E4A52AC865EB40 # opencpn
gpg --no-default-keyring --keyring /usr/share/keyrings/fredericguilbaultppa-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 868273edce9979e7 # PPA Frederic Guilbault
gpg --no-default-keyring --keyring /usr/share/keyrings/bbnppa-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 24A4598E769C8C51 # BBN PPA Mikhail Grushinskiy
gpg --keyserver keyserver.ubuntu.com --recv-key 868273edce9979e7
gpg --no-default-keyring --keyring /usr/share/keyrings/tualatrix-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 6AF0E1940624A220 # TualatriX
wget -q -O- https://apt.mopidy.com/mopidy.gpg | gpg --dearmor > /usr/share/keyrings/mopidy-archive-keyring.gpg & #Mopidy
wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > /usr/share/keyrings/nodesource-archive-keyring.gpg & # NodeJs
wget -q -O- https://www.free-x.de/debian/oss.boating.gpg.key | gpg --dearmor > /usr/share/keyrings/oss.boating-archive-keyring.gpg & # XyGrib
wget -q -O- https://repo.mobian-project.org/mobian.gpg.key  | gpg --dearmor > /usr/share/keyrings/mobian-archive-keyring.gpg & # mobian

## Update && Upgrade
apt-get update  -yq || true
apt-get upgrade -yq || true
gpgconf --kill gpg-agent
gpgconf --kill dirmngr
## Block vscode addition
DEBIAN_FRONTEND=noninteractive apt-get install -yq -o Dpkg::Options::="--force-confnew" block-vscode-repository || true