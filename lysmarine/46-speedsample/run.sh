#!/bin/bash -e

apt install -y nodejs libavahi-compat-libdnssd-dev python-dev libsqlite3-0 g++
npm cache verify

        echo " - Install speedsample"
        cd /var/www/
        git clone --depth=1 https://gitlab.com/FredericGuilbault/speedSample
        cd speedSample;
        npm install -g --unsafe-perm  --cache /tmp/empty-cache46;
        cd $FILE_FOLDER/../../
        pwd

install -m 644 -v $FILE_FOLDER/speedsample.service  "/etc/systemd/system/speedsample.service"

chown -R www-data:www-data /var/www/speedSample

systemctl enable speedsample.service
