#!/bin/bash -e

apt-get install -y -q wget gnupg dirmngr
gpg --list-keys
## Add the extended sources software source for Debian
#sed -i "s/deb\.debian\.org\/debian\/\ bullseye\ main/deb\.debian\.org\/debian\/\ bullseye\ main\ contrib\ non-free/g" /etc/apt/sources.list

## Add the extended sources software source for Debian
if [ "$(lsb_release -id -s | head -1)" = "Raspbian" ]  ; then
  apt-get install -y debian-keyring  # debian only
  apt-get install -y debian-archive-keyring  # debian only
  apt-get install -y apt-transport-https
fi

if [ "$(lsb_release -id -s | head -1)" = "Raspbian" ]  ; then
  gpg --no-default-keyring --keyring /usr/share/keyrings/debian-release-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 0E98404D386FA1D9
  gpg --no-default-keyring --keyring /usr/share/keyrings/debian-release-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 605C66F00D6C9793
  gpg --no-default-keyring --keyring /usr/share/keyrings/debian-release-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 648ACFD622F3D138

  install -m0644 -v $FILE_FOLDER/debian.list  "/etc/apt/sources.list.d/"
  install -m0644 -v $FILE_FOLDER/40-debian.pref "/etc/apt/preferences.d/"
fi

## Add repository sources
install -m0644 -v $FILE_FOLDER/nodesource.list "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/xygrib.list     "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/lysmarine.list  "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/debian-pm.list  "/etc/apt/sources.list.d/"
install -m0644 -v $FILE_FOLDER/openplotter.list  "/etc/apt/sources.list.d/"

## Prefer opencpn's PPA to free-x
install -m0644 -v $FILE_FOLDER/50-lysmarine.pref "/etc/apt/preferences.d/"

install -m0644 -v $FILE_FOLDER/60-nodesource.pref "/etc/apt/preferences.d/"

## Get the signatures
gpg --list-keys
gpg --no-default-keyring --keyring /usr/share/keyrings/fredericguilbaultppa-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 868273edce9979e7 # PPA Frederic Guilbault
gpg --no-default-keyring --keyring /usr/share/keyrings/tualatrix-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 6AF0E1940624A220 # TualatriX
wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > /usr/share/keyrings/nodesource-archive-keyring.gpg & # NodeJs
wget -q -O- https://www.free-x.de/debian/oss.boating.gpg.key | gpg --dearmor > /usr/share/keyrings/oss.boating-archive-keyring.gpg & # XyGrib

## Add plasma-mobile
wget https://jbb.ghsq.ga/debpm/pool/main/d/debian-pm-repository/debian-pm-archive-keyring_20210819_all.deb
dpkg -i debian-pm-archive-keyring_20210819_all.deb
rm debian-pm-archive-keyring_20210819_all.deb

## OpenCPN
curl -1sLf 'https://dl.cloudsmith.io/public/openplotter/openplotter/gpg.130548C2FC9B50FD.key' |  gpg --dearmor > /usr/share/keyrings/openplotter-openplotter-archive-keyring.gpg
#curl -1sLf 'https://dl.cloudsmith.io/public/openplotter/openplotter/config.deb.txt?distro=ubuntu&codename=xenial' > /etc/apt/sources.list.d/openplotter-openplotter.list

apt-get update

## Update && Upgrade
apt-get update  -yq || true
apt-get upgrade -yq || true
gpgconf --kill gpg-agent
gpgconf --kill dirmngr

wait;