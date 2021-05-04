#!/bin/bash -e

apt-get -y -q install piaware dump1090-fa

sed -i 's/= 80/= 8186/' /etc/lighttpd/lighttpd.conf

systemctl disable lighttpd
systemctl disable dump1090-fa
