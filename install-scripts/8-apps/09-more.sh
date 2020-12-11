#!/bin/bash -e

sudo apt-get -q -y install i2c-tools traceroute telnet socat gdal-bin

sudo apt-get -q -y install dconf-editor gedit gnome-weather gnome-chess openpref

sudo apt-get -q -y install arduino

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/deskpi-pro-install.sh "/home/user/add-ons/"

