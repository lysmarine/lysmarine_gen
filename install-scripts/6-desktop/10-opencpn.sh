#!/bin/bash -e
apt-get install -y -q opencpn

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"

## Add specifics window placement rules for opencpn in plasma-mobile.
install -o 1000 -g 1000 -d -m 755 /home/user/.config
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/kwinrulesrc "/home/user/.config/"