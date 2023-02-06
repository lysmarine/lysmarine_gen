#!/bin/bash

apt-get install -yq git nodejs python-dev

## Dependencies of signalk.
apt-get install -yq libavahi-compat-libdnssd-dev


install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/node_modules/"

install    -m 644 -o signalk -g signalk $FILE_FOLDER/set-system-time.json  "/home/signalk/.signalk/plugin-config-data/"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/charts.json  "/home/signalk/.signalk/plugin-config-data/"

install    -m 644 -o signalk -g signalk $FILE_FOLDER/defaults.json  "/home/signalk/.signalk/defaults.json"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/package.json   "/home/signalk/.signalk/package.json"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/settings.json  "/home/signalk/.signalk/settings.json"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/security.json  "/home/signalk/.signalk/security.json"
install    -m 755 -o signalk -g signalk $FILE_FOLDER/signalk-server "/home/signalk/.signalk/signalk-server"

install  $FILE_FOLDER/signalk.service "/etc/systemd/system/"

## Install signalk
npm install -g --unsafe-perm signalk-server



## Install signalk published plugin
pushd /home/signalk/.signalk
	su signalk -c "npm install @signalk/charts-plugin --unsafe-perm --loglevel error"
    su signalk -c "npm install @mxtommy/kip --unsafe-perm --loglevel error"
	# su signalk -c "npm install signalk-world-coastline-map --unsafe-perm --loglevel error" # this npm package is broken
popd



## Install signalk lysmarine-dashboard plugin
pushd /home/signalk/.signalk/node_modules/@signalk/
	su signalk -c "git clone https://github.com/lysmarine/lysmarine-dashboard"
	pushd ./lysmarine-dashboard
	    rm -r .git
	    npm install
    popd
popd

## Give set-system-time the possibility to change the date.
echo "signalk ALL=(ALL) NOPASSWD: /bin/date" >> /etc/sudoers

## For Seatalk
#apt-get install -y -q pigpio python-pigpio python3-pigpio
#systemctl disable pigpiod

## For Seatalk
# https://github.com/MatsA/seatalk1-to-NMEA0183
# https://github.com/Thomas-GeDaD/Seatalk1-Raspi-reader
#wget -q -O - https://raw.githubusercontent.com/MatsA/seatalk1-to-NMEA0183/master/STALK_read.py > /usr/local/sbin/STALK_read.py

#apt-get install -y -q python3-rpi.gpio