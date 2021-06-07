#!/bin/bash -e

apt-get -y -q install shairport-sync

install -v -m 0644 $FILE_FOLDER/shairport-sync.conf "/etc/"

systemctl enable shairport-sync

usermod -aG gpio shairport-sync

apt-get clean
