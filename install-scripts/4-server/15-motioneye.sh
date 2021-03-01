#!/bin/bash -e

apt-get clean

# See https://github.com/ccrisan/motioneye/wiki/Install-On-Raspbian

apt-get -y -q install libcurl4-openssl-dev libssl-dev
apt-get -y -q install ffmpeg libmariadb3 libpq5 libmicrohttpd12
apt-get -y -q install motion
apt-get -y -q install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev

pip install --upgrade motioneye

mkdir -p /etc/motioneye
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

mkdir -p /var/lib/motioneye

cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
#systemctl daemon-reload
systemctl disable motioneye
#systemctl start motioneye

apt-get clean

# http://localhost:8765/
# default user admin
# password is empty
