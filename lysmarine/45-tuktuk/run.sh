#!/bin/bash -e

apt-get install -y nodejs git python-dev  libsqlite3-0 g++

echo " - Install tuktuk"
if [ ! id -u www-data >/dev/null 2>&1 ] ; then
	adduser --disabled-login --home /var/www www-data
fi

if [ ! -d /var/www  ] ; then
	mkdir /var/www
	chown www-data:www-data /var/www
fi


git clone  --branch lysmarine/master https://gitlab.com/FredericGuilbault/tuktuk-chart-plotter /var/www/tuktuk-chart-plotter
pushd /var/www/tuktuk-chart-plotter
npm cache verify
npm install -g --unsafe-perm --loglevel error  --cache /tmp/empty-cache45;
echo " -package Install done"
npm install --unsafe-perm --loglevel error webpack

NODE_ENV=production npm run bundle:js
NODE_ENV=production npm run bundle:css
echo " - Bundle done"

popd
echo " Compiling Done for tuktuk"

install ./files/client-config.json "/var/www/tuktuk-chart-plotter/client-config.json"
install -m 644 -v ./files/tuktuk.service  "/etc/systemd/system/tuktuk.service"

systemctl enable tuktuk.service

chown -R www-data:www-data /var/www/tuktuk-chart-plotter
rm -rf /var/www/tuktuk-chart-plotter/charts
ln -s  /srv/charts /var/www/tuktuk-chart-plotter/charts;
