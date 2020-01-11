#!/bin/bash

## Create signalk user to run the server.
if [ ! -d /home/signalk ] ; then
	adduser --home /home/signalk --gecos --disabled-password --disabled-login signalk
fi

## Create a user group that are allowed to write on the charts folder.
if ! grep -q charts /etc/group ; then
	groupadd charts;
	usermod -a -G charts signalk;
	usermod -a -G charts pi;
	usermod -a -G charts root;
fi

## Create the charts folder.
install -v -d -m 0775 -o signalk -g charts /srv/charts;

## Link the chart folder to home for convenience.
if [ ! -f /home/pi/charts ] ; then
	ln -s /srv/charts /home/pi/charts;
fi

## Dependencys of signalk.
apt-get install -y -q nodejs libavahi-compat-libdnssd-dev python-dev

install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/set-system-time.json  "/home/signalk/.signalk/plugin-config-data/"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/charts.json  "/home/signalk/.signalk/plugin-config-data/"

install    -m 644 -o signalk -g signalk $FILE_FOLDER/defaults.json  "/home/signalk/.signalk/defaults.json"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/package.json   "/home/signalk/.signalk/package.json"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/settings.json  "/home/signalk/.signalk/settings.json"
install    -m 755 -o signalk -g signalk $FILE_FOLDER/signalk-server "/home/signalk/.signalk/signalk-server"
install -d        -o signalk -g signalk "/home/pi/.local/share/icons/"

install    -m 644 -o 1000    -g 1000    $FILE_FOLDER/signalk.png "/home/pi/.local/share/icons/"
install -d                              /etc/systemd/system
install    -m 644                       $FILE_FOLDER/signalk.service "/etc/systemd/system/signalk.service"
install    -m 644                       $FILE_FOLDER/signalk.socket  "/etc/systemd/system/signalk.socket"

ln -sf "/etc/systemd/system/signalk.service" "/etc/systemd/system/multi-user.target.wants/signalk.service"
ln -sf "/etc/systemd/system/signalk.socket"  "/etc/systemd/system/multi-user.target.wants/signalk.socket"

## This is problematic and have been fixed: Waiting for  @signalk/set-system-time@1.3.0.... https://github.com/SignalK/set-system-time/pull/5
# echo "signalk ALL=(ALL) NOPASSWD: /bin/date" >> /etc/sudoers
## Meanwhile :
echo "signalk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

## Install signalk
npm install --loglevel error -g --unsafe-perm signalk-server

## Install signalk plugins
pushd /home/signalk/.signalk
su signalk -c "npm install @signalk/charts-plugin --unsafe-perm --loglevel error"
popd
