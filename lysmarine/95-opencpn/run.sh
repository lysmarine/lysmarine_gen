#!/bin/bash -e

install -o 1000 -g 1000 -d "/home/dietpi/.opencpn"
install -o 1000 -g 1000  -v $FILE_FOLDER/opencpn.conf    "/home/dietpi/.opencpn/"

apt-get install -y opencpn opencpn-plugin-*
