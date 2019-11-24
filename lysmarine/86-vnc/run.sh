#!/bin/bash -e

apt-get install -y x11vnc

cp $FILE_FOLDER/vnc.service "/etc/systemd/system/vnc.service"

install -o 1000 -g 1000  -d "/home/pi/.vnc"
install -o 1000 -g 1000 $FILE_FOLDER/passwd "/home/pi/.vnc/passwd"

# x11vnc -storepasswd SECRETPASSWORD /home/pi/.vnc/passwd
systemctl enable vnc
