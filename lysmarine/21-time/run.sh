#!/bin/bash -e

apt-get install -y -q chrony

systemctl disable systemd-timesyncd

echo "" >>  /etc/chrony/chrony.conf
echo "# For data comming from signalk" >>  /etc/chrony/chrony.conf
echo "refclock SHM 0 offset 0.5 delay 0.2 refid NMEA" >>  /etc/chrony/chrony.conf
