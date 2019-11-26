#!/bin/bash -e

apt-get install -y -q x11vnc

install -v                    $FILE_FOLDER/vnc.service "/etc/systemd/system/vnc.service"
install -v -d -o 1000 -g 1000 "/home/pi/.vnc"
install -v    -o 1000 -g 1000 $FILE_FOLDER/passwd "/home/pi/.vnc/passwd"

systemctl enable vnc

## NOTE: The password file have been generated with the command
## x11vnc -storepasswd SECRETPASSWORD /home/pi/.vnc/passwd
