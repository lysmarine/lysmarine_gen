#!/bin/bash -e

## Dependencies of signalk.
apt-get install -y -q python-dev git nodejs \
 libnss-mdns libavahi-compat-libdnssd-dev avahi-utils \
 node-abstract-leveldown node-nan libzmq3-dev libkrb5-dev

npm install -g npm@latest

install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/node_modules/"

install -m 644 -o signalk -g signalk $FILE_FOLDER/set-system-time.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/sk-to-nmae0183.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/charts.json "/home/signalk/.signalk/plugin-config-data/"

install -m 644 -o signalk -g signalk $FILE_FOLDER/defaults.json "/home/signalk/.signalk/defaults.json"
install -m 644 -o signalk -g signalk $FILE_FOLDER/package.json "/home/signalk/.signalk/package.json"
install -m 644 -o signalk -g signalk $FILE_FOLDER/settings.json "/home/signalk/.signalk/settings.json"
install -m 755 -o signalk -g signalk $FILE_FOLDER/signalk-server "/home/signalk/.signalk/signalk-server"
install -m 755 $FILE_FOLDER/signalk-restart "/usr/local/sbin/signalk-restart"

install -d -o signalk -g signalk "/home/user/.local/share/icons/"
install -m 644 -o 1000 -g 1000 $FILE_FOLDER/icons/signalk.png "/home/user/.local/share/icons/"

install -d /etc/systemd/system
install -m 644 $FILE_FOLDER/signalk.service "/etc/systemd/system/signalk.service"

## Install signalk
npm cache clean --force
npm install -g --unsafe-perm signalk-server
npm cache clean --force

## Install signalk published plugin
pushd /home/signalk/.signalk
  su signalk -c "npm install @signalk/charts-plugin  \
                 sk-resources-fs  \
                 freeboard-sk-helper  \
                 skwiz  \
                 tuktuk-chart-plotter  \
                 signalk-raspberry-pi-bme280  \
                 signalk-raspberry-pi-1wire  \
                 signalk-venus-plugin  \
                 signalk-mqtt-gw  \
                 signalk-mqtt-home-asisstant  \
                 @codekilo/signalk-modbus-client  \
                 signalk-derived-data  \
                 signalk-anchoralarm-plugin  \
                 signalk-simple-notifications  \
                 signalk-wilhelmsk-plugin  \
                 signalk-to-nmea2000  \
                 @signalk/sailgauge  \
                 @signalk/signalk-autopilot  \
                 signalk-sonoff-ewelink  \
                 signalk-raspberry-pi-monitoring  \
                 @mxtommy/kip  \
                 signalk-fusion-stereo  \
                 signalk-barometer-trend  \
                 @oehoe83/signalk-raspberry-pi-bme680  \
                 signalk-threshold-notifier  \
                 signalk-saillogger --unsafe-perm --loglevel error"
popd

sed -i "s#sudo ##g" /home/signalk/.signalk/node_modules/signalk-raspberry-pi-monitoring/index.js
sed -i "s#/opt/vc/bin/##g" /home/signalk/.signalk/node_modules/signalk-raspberry-pi-monitoring/index.js

## Install signalk lysmarine-dashboard plugin
#pushd /home/signalk/.signalk/node_modules/@signalk/
#  su signalk -c "git clone https://github.com/lysmarine/lysmarine-dashboard"
#  pushd ./lysmarine-dashboard
#    rm -rf .git
#    npm install
#  popd
#popd

## Give set-system-time the possibility to change the date.
echo "signalk ALL=(ALL) NOPASSWD: /bin/date" >>/etc/sudoers

## Make some space on the drive for the next stages
npm cache clean --force

# For Seatalk
apt-get install -y -q pigpio python-pigpio python3-pigpio python3-rpi.gpio
systemctl disable pigpiod

# For Seatalk
wget -q -O - https://raw.githubusercontent.com/MatsA/seatalk1-to-NMEA0183/master/STALK_read.py > /usr/local/sbin/STALK_read.py

echo "" >>/etc/sudoers
echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/signalk-restart' >>/etc/sudoers

systemctl enable signalk



