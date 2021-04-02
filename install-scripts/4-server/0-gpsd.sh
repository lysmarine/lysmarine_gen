#!/bin/bash -e

apt-get install -y -q gpsd #gpsd-clients

## Automatically start gpsd when a USB gps is detected.
install -d /etc/udev/rules.d
install -v $FILE_FOLDER/90-lys-gps.rules "/etc/udev/rules.d/90-lys-gps.rules"

install -d /usr/local/bin
install -v -m 0755 $FILE_FOLDER/manage_gps.sh "/lib/udev/manage_gps.sh"
