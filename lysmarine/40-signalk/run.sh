#!/bin/bash -e

if [ ! -d /home/signalk ] ; then
        adduser --home /home/signalk --gecos --disabled-password --disabled-login signalk
fi


if ! grep -q charts /etc/group
 then
        groupadd charts;
        usermod -a -G charts signalk;
        usermod -a -G charts dietpi;
        usermod -a -G charts root;
        mkdir -m 775 /srv/charts;
fi


chown signalk:charts /srv/charts;
chmod ug+s /srv/charts;
ln -s /srv/charts /home/dietpi/charts;

apt-get install -y nodejs libavahi-compat-libdnssd-dev python-dev

install -m 755 -o signalk -g signalk  -d "/home/signalk/.signalk"
install -m 755 -o signalk -g signalk  -d "/home/signalk/.signalk/plugin-config-data"
install -m 644 -o signalk -g signalk   $FILE_FOLDER/set-system-time.json  "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk   $FILE_FOLDER/charts.json  "/home/signalk/.signalk/plugin-config-data/"

install -m 644 -o signalk -g signalk   $FILE_FOLDER/defaults.json  "/home/signalk/.signalk/defaults.json"
install -m 644 -o signalk -g signalk   $FILE_FOLDER/package.json   "/home/signalk/.signalk/package.json"
install -m 644 -o signalk -g signalk   $FILE_FOLDER/settings.json  "/home/signalk/.signalk/settings.json"
install -m 755 -o signalk -g signalk   $FILE_FOLDER/signalk-server "/home/signalk/.signalk/signalk-server"
install -d -o signalk -g signalk   "/home/dietpi/.local/share/icons/"

install -m 644 -o 1000 -g 1000   $FILE_FOLDER/signalk.png "/home/dietpi/.local/share/icons/"
install -d /etc/systemd/system
install -m 644 $FILE_FOLDER/signalk.service "/etc/systemd/system/signalk.service"
install -m 644 $FILE_FOLDER/signalk.socket  "/etc/systemd/system/signalk.socket"

ln -sf "/etc/systemd/system/signalk.service" "/etc/systemd/system/multi-user.target.wants/signalk.service"
ln -sf "/etc/systemd/system/signalk.socket"  "/etc/systemd/system/multi-user.target.wants/signalk.socket"

echo "signalk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

npm install --loglevel error -g --unsafe-perm signalk-server
cd /home/signalk/.signalk
su signalk -c "npm install @signalk/charts-plugin --unsafe-perm --loglevel error"
