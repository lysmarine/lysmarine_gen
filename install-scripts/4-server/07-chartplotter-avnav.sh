#!/bin/bash -e

apt-get clean

sudo apt-get -q -y --no-install-recommends install avnav xterm mpg123

install -o 1000 -g 1000 -d /home/user/AvNavCharts
install -o 1000 -g 1000 -d /home/user/AvNavCharts/out

adduser avnav audio

usermod -a -G charts avnav

systemctl enable avnav

install -m 644 $FILE_FOLDER/avnav.desktop "/usr/local/share/applications/"

apt-get clean
npm cache clean --force
