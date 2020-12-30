#!/bin/bash -e

## Add repository sources
install -m0644 -v $FILE_FOLDER/nodesource.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/opencpn.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/xygrib.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/lysmarine.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/evdev-rce.list "/etc/apt/sources.list.d/"

## Prefer opencpn PPA to free-x (for mainly for the opencpn package)
install -m0644 -v $FILE_FOLDER/50-lysmarine.pref "/etc/apt/preferences.d/"

## Get the signature keys
apt-get install -y -q  wget gnupg
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40          # Opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220          # Opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 868273edce9979e7          # lysmarine (provide: rtl-ais, lysmarine )
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 24A4598E769C8C51          # BBN (evdev-rce)
wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add     #NodeJs
wget -q -O- https://www.free-x.de/debian/oss.boating.gpg.key     | apt-key add -   # XyGrib

## Update && Upgrade
apt-get update  -y -q
apt-get upgrade -y -q