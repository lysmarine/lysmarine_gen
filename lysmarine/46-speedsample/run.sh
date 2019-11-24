#!/bin/bash -e


apt install -y nodejs libavahi-compat-libdnssd-dev python-dev libsqlite3-0 g++
npm cache verify
if [ ! id -u www-data >/dev/null 2>&1 ] ; then
	adduser --disabled-login --home /var/www www-data
fi

if [ ! -d /var/www  ] ; then
	mkdir /var/www
	chown www-data:www-data /var/www
fi


pushd /var/www/
git clone --depth=1 https://gitlab.com/FredericGuilbault/speedSample
popd
pushd /var/www/speedSample;
npm install -g --unsafe-perm  --cache /tmp/empty-cache46;
popd
chown -R www-data:www-data /var/www/speedSample

install -m 644 -v $FILE_FOLDER/speedsample.service  "/etc/systemd/system/speedsample.service"

systemctl enable speedsample.service
