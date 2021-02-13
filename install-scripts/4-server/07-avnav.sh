#!/bin/bash -e

apt-get clean

apt-get -q -y --no-install-recommends install avnav mpg123

apt-get -q -y install avnav-history-plugin avnav-ocharts-plugin # avnav-raspi

apt-get -q -y -o Dpkg::Options::="--force-overwrite" install avnav-oesenc

apt-get -q -y install avnav-mapproxy-plugin

install -o 0 -g 0 -m 0644 $FILE_FOLDER/lys-avnav.conf /usr/lib/systemd/system/avnav.service.d/
install -o 0 -g 0 -d /usr/lib/avnav/lysmarine
install -o 0 -g 0 -m 0644 $FILE_FOLDER/avnav_server_lysmarine.xml "/usr/lib/avnav/lysmarine/" 

systemctl enable avnav

#install -d -o avnav -g avnav /home/avnav

apt-get clean
npm cache clean --force
