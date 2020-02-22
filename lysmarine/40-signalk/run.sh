#!/bin/bash

## Create a user group that are allowed to write on the charts folder.
if ! grep -q charts /etc/group ; then
	groupadd charts;
	usermod -a -G charts signalk;
	usermod -a -G charts user;
	usermod -a -G charts root;
fi

## Create the charts folder.
install -v -d -m 6775 -o signalk -g charts /srv/charts;



## Dependencys of signalk.
apt-get install -y -q nodejs libavahi-compat-libdnssd-dev python-dev
if [ $LMBUILD == debian-amd64 ] ;then
	apt-get install -y -q npm
fi



install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/set-system-time.json  "/home/signalk/.signalk/plugin-config-data/"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/charts.json  "/home/signalk/.signalk/plugin-config-data/"

install    -m 644 -o signalk -g signalk $FILE_FOLDER/defaults.json  "/home/signalk/.signalk/defaults.json"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/package.json   "/home/signalk/.signalk/package.json"
install    -m 644 -o signalk -g signalk $FILE_FOLDER/settings.json  "/home/signalk/.signalk/settings.json"
install    -m 755 -o signalk -g signalk $FILE_FOLDER/signalk-server "/home/signalk/.signalk/signalk-server"
install -d        -o signalk -g signalk "/home/user/.local/share/icons/"

install    -m 644 -o 1000    -g 1000    $FILE_FOLDER/signalk.png "/home/user/.local/share/icons/"
install -d                              /etc/systemd/system
install    -m 644                       $FILE_FOLDER/signalk.service "/etc/systemd/system/signalk.service"
install    -m 644                       $FILE_FOLDER/signalk.socket  "/etc/systemd/system/signalk.socket"

ln -sf "/etc/systemd/system/signalk.service" "/etc/systemd/system/multi-user.target.wants/signalk.service"
ln -sf "/etc/systemd/system/signalk.socket"  "/etc/systemd/system/multi-user.target.wants/signalk.socket"



## Install signalk
npm install --loglevel error -g --unsafe-perm signalk-server



## Install signalk plugins
pushd /home/signalk/.signalk
su signalk -c "npm install @signalk/charts-plugin --unsafe-perm --loglevel error"
# su signalk -c "npm install signalk-world-coastline-map --unsafe-perm --loglevel error" # this npm package is broken
popd

## Give set-system-time the possibility to change the date. 
echo "signalk ALL=(ALL) NOPASSWD: /bin/date" >> /etc/sudoers



## Make some space on the drive for the next stages
rm -r /tmp/npm-*