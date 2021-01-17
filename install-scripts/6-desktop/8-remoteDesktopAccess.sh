#!/bin/bash -e

apt-get install -yq x11vnc

install -v -d -o 1000 -g 1000 "/home/user/.vnc"
install -v    -o 1000 -g 1000 $FILE_FOLDER/passwd "/home/user/.vnc/passwd"

## NOTE: The password file have been generated with the command
## x11vnc -storepasswd SECRETPASSWORD /home/user/.vnc/passwd

apt-get install -yq xrdp
install -v $FILE_FOLDER/Xwrapper.config "/etc/X11/Xwrapper.config"
