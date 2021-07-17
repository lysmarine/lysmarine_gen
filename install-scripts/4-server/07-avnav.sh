#!/bin/bash -e

apt-get clean

apt-get -q -y --no-install-recommends install avnav xterm mpg123

apt-get -q -y install avnav-history-plugin avnav-ocharts-plugin avnav-more-nmea-plugin avnav-mapproxy-plugin # avnav-raspi

apt-get -q -y -o Dpkg::Options::="--force-overwrite" install avnav-oesenc

install -o 0 -g 0 -d /usr/lib/systemd/system/avnav.service.d
install -o 0 -g 0 -m 0644 $FILE_FOLDER/lys-avnav.conf /usr/lib/systemd/system/avnav.service.d/
install -o 0 -g 0 -d /usr/lib/avnav/lysmarine
install -o 0 -g 0 -m 0644 $FILE_FOLDER/avnav_server_lysmarine.xml "/usr/lib/avnav/lysmarine/" 

install -m 755 $FILE_FOLDER/avnav-restart "/usr/local/sbin/avnav-restart"

apt-get clean
npm cache clean --force

echo "" >>/etc/sudoers
echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/avnav-restart' >>/etc/sudoers

usermod -a -G lirc avnav

chown user:user /home/user/avnav/data/*

systemctl enable avnav
