#!/bin/bash -e
apt-get install -y gsimplecal pavucontrol libgtk2.0-dev tint2 libatk-adaptor

## Install configuration files.
install -o 1000 -g 1000 -d "/home/user/.config/tint2"
install -o 1000 -g 1000 $FILE_FOLDER/tint2rc "/home/user/.config/tint2/tint2rc"

## Start tint2 on openbox boot.
install -o 1000 -g 1000 -d /home/user/.config/openbox
echo 'tint2 &' >>/home/user/.config/openbox/autostart
