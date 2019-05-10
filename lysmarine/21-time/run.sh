#!/bin/bash -e

apt-get install -y chrony

systemctl disable systemd-timesyncd

echo "# https://photobyte.org/raspberry-pi-stretch-gps-dongle-as-a-time-source-with-chrony-timedatectl/" >>  /etc/chrony/chrony.conf
echo "# http://catb.org/gpsd/gpsd-time-service-howto.html#_feeding_chrony_from_gpsd" >>  /etc/chrony/chrony.conf

echo "refclock SHM 0 offset 0.5 delay 0.2 refid NMEA" >>  /etc/chrony/chrony.conf
