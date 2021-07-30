#!/bin/bash -e

apt-get -y -q install shairport-sync usbmuxd

install -v -m 0644 $FILE_FOLDER/shairport-sync.conf "/etc/"

usermod -aG gpio shairport-sync

systemctl enable shairport-sync

apt-get clean
