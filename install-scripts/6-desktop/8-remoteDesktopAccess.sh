#!/bin/bash -e

apt-get install -y -q --no-install-recommends x11vnc

install -v -m 644             $FILE_FOLDER/vnc.service "/etc/systemd/system/vnc.service"
install -v -d -o 1000 -g 1000 "/home/user/.vnc"
install -v    -o 1000 -g 1000 $FILE_FOLDER/passwd "/home/user/.vnc/passwd"

systemctl enable vnc

## NOTE: The password file have been generated with the command
## x11vnc -storepasswd SECRETPASSWORD /home/user/.vnc/passwd

#install -d /etc/systemd/system/xrdp.d
#
#apt-get install -y -q --no-install-recommends xrdp
#install -v $FILE_FOLDER/Xwrapper.config "/etc/X11/Xwrapper.config"
