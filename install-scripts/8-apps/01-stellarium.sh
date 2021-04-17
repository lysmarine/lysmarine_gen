#!/bin/bash -e

apt-get clean

apt-get -y -q install stellarium

install -d -o 1000 -g 1000 -m 0755 "/home/user/.stellarium"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/stellarium-config.ini "/home/user/.stellarium/config.ini"

install -v -m 0644 $FILE_FOLDER/stellarium.desktop /usr/share/applications/
install -v -m 0755 $FILE_FOLDER/stellarium-augmented.sh /usr/local/bin/stellarium-augmented

apt-get -y -q install geographiclib-tools

geographiclib-get-magnetic all

apt-get clean
