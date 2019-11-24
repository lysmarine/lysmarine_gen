#!/bin/bash -e
apt-get install -y libgtk2.0-dev

install -vd "/etc/systemd/system/getty@tty1.service.d"
install -v $FILE_FOLDER/autologin.conf "/etc/systemd/system/getty@tty1.service.d"
install -v -o 1000 -g 1000 $FILE_FOLDER/profile "/home/pi/.profile"


systemctl enable getty@tty1.service
