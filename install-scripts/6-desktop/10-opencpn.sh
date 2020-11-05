#!/bin/bash -e

apt-get install -y -q opencpn

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"
