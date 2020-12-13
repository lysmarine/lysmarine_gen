#!/bin/bash -e

sudo apt-get -q -y install i2c-tools traceroute telnet socat gdal-bin

sudo apt-get -q -y install dconf-editor gedit gnome-weather gnome-chess openpref

sudo apt-get -q -y install arduino

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/add-ons/readme.txt "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/deskpi-pro-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/qtvlm-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-sample.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/wxtoimg-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/noaa-apt-install.sh "/home/user/add-ons/"
