#!/bin/bash -e

install -o 1000 -g 1000 -d "/home/pi/.opencpn"
install -o 1000 -g 1000  -v $FILE_FOLDER/opencpn.conf    "/home/pi/.opencpn/"

apt-get install -y opencpn opencpn-plugin-*
