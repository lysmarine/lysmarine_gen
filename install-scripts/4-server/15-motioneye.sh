#!/bin/bash -e

apt-get clean

# See https://github.com/ccrisan/motioneye/wiki/Install-On-Raspbian

apt-get -y -q install motion

python3 -m pip install --upgrade motioneye

mkdir -p /etc/motioneye
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

mkdir -p /var/lib/motioneye

cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
#systemctl daemon-reload
systemctl enable motioneye
#systemctl start motioneye

apt-get clean
