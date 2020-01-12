#!/bin/bash

install -v -d              "/etc/systemd/system/getty@tty1.service.d"
install -v -m644           $FILE_FOLDER/autologin.conf "/etc/systemd/system/getty@tty1.service.d"
install -v -o 1000 -g 1000 $FILE_FOLDER/profile "/home/user/.profile"

systemctl enable getty@tty1.service
