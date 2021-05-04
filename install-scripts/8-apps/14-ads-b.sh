#!/bin/bash -e

apt-get -y -q install dump1090-fa piaware

sed -i 's/= 80/= 8186/' /etc/lighttpd/lighttpd.conf

systemctl disable lighttpd
systemctl disable dump1090-fa
systemctl disable piaware
