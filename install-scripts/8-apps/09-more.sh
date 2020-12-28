#!/bin/bash -e

apt-get clean
npm cache clean --force

apt-get -q -y install i2c-tools traceroute telnet socat gdal-bin openvpn

apt-get -q -y install dconf-editor gedit gnome-weather gnome-chess openpref

apt-get clean

apt-get -q -y install rsync timeshift snapd

#apt-get install software-properties-common

apt-get clean
npm cache clean --force

apt-get -q -y install arduino

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/add-ons/readme.txt "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/deskpi-pro-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-sample.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/wxtoimg-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/pactor-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/nmea-sleuth-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/tuktuk-install.sh "/home/user/add-ons/"

if [ "$LMARCH" == 'armhf' ]; then
  install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/qtvlm-install.sh "/home/user/add-ons/"
fi

install -v $FILE_FOLDER/bbn-checklist.desktop "/usr/local/share/applications/"

install -d -m 0755 "/usr/local/share/colreg"
curl 'https://en.wikisource.org/api/rest_v1/page/pdf/International_Regulations_for_Preventing_Collisions_at_Sea' \
 -H 'Accept: */*;q=0.8' \
 -H 'Accept-Language: en-US,en;q=0.5' --compressed \
 -H 'DNT: 1' -H 'Connection: keep-alive' \
 -H 'Upgrade-Insecure-Requests: 1' -H 'TE: Trailers' \
 --output "/usr/local/share/colreg/colreg.pdf"
install -v $FILE_FOLDER/colreg.desktop "/usr/local/share/applications/"

install -d -m 0755 "/usr/local/share/knots"
install -v -m 0644 $FILE_FOLDER/knots/knots.html "/usr/local/share/knots/"
install -v -m 0644 $FILE_FOLDER/knots/knots.svg "/usr/local/share/knots/"
install -v -m 0644 $FILE_FOLDER/knots/License_free.txt "/usr/local/share/knots/"
install -v $FILE_FOLDER/knots.desktop "/usr/local/share/applications/"
