#!/bin/bash -e

apt-get update  -y -q
apt-get install -y -q  wget gnupg ca-certificates
apt-get upgrade -y -q

## Add repository sources
install -m 0644 -v $FILE_FOLDER/nodesource.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/opencpn.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/xygrib.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/lysmarine.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/bbn-rce.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/bbn-kplex.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/bbn-noaa-apt.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/mopidy.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/avnav.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/mosquitto.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/influxdb.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/grafana.list "/etc/apt/sources.list.d/"
install -m 0644 -v $FILE_FOLDER/openplotter.list "/etc/apt/sources.list.d/"

## Prefer opencpn PPA to free-x (for mainly for the opencpn package)
install -m 0644 -v $FILE_FOLDER/50-lysmarine.pref "/etc/apt/preferences.d/"

## Get the signature keys
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40           # Opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220           # Opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 868273EDCE9979E7           # lysmarine (provide: createap, rtl-ais, fbpanel)
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 24A4598E769C8C51           # bbn PPAs on launchpad

wget -q -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -    # NodeJs
wget -q -O - https://www.free-x.de/debian/oss.boating.gpg.key     | apt-key add -    # XyGrib, AvNav
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-rce/gpg.540A03461CECBA19.key | apt-key add -
#curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-kplex/gpg.B487196268D0D9B6.key | apt-key add -
curl -1sLf https://dl.cloudsmith.io/public/bbn-projects/bbn-noaa-apt/gpg.DB5121F72251E833.key | apt-key add -
wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
curl https://open-mind.space/repo/open-mind.space.gpg.key | apt-key add -     # AvNav
wget -q -O - https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add - # Mosquitto
wget -q -O - https://repos.influxdata.com/influxdb.key | apt-key add -
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
wget -q -O - https://raw.githubusercontent.com/openplotter/openplotter-settings/master/openplotterSettings/data/sources/openplotter.gpg.key | apt-key add -

## Update && Upgrade
apt-get update  -y -q
apt-get upgrade -y -q
