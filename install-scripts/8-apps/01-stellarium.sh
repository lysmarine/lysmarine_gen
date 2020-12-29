#!/bin/bash -e

apt-get clean

apt-get -y -q install stellarium

install -d -o 1000 -g 1000 -m 0755 "/home/user/.stellarium"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/stellarium-config.ini "/home/user/.stellarium/config.ini"

apt-get clean
