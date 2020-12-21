#!/bin/bash -e

apt-get clean

install -o 1000 -g 1000 -d /home/user/AvNavCharts
install -o 1000 -g 1000 -d /home/user/AvNavCharts/out
install -o 1000 -g 1000 -d /var/lib/avnav

apt-get -q -y --no-install-recommends install avnav xterm mpg123

adduser avnav audio

usermod -a -G charts avnav

install -m 0644 $FILE_FOLDER/avnav_server_lysmarine.xml "/var/lib/avnav/avnav_server_lysmarine.xml"
install -m 0644 $FILE_FOLDER/avnav_server_lysmarine.xml "/var/lib/avnav/avnav_server.xml"

systemctl enable avnav

install -d -o avnav -g avnav /home/avnav

apt-get clean
npm cache clean --force
