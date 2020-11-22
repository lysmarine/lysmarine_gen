#!/bin/bash

install -v -m644 $FILE_FOLDER/startx.service "/etc/systemd/system/startx.service"

systemctl enable startx.service
systemctl set-default graphical.target