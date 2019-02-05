#!/bin/bash -e
on_chroot <<EOF
echo 'START_DAEMON="true"' > /etc/default/gpsd
echo 'USBAUTO="true"' >> /etc/default/gpsd
echo 'DEVICES="/dev/ttyUSB0"' >> /etc/default/gpsd
echo 'GPSD_OPTIONS=" -n "' >> /etc/default/gpsd
EOF
