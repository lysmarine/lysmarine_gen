#!/bin/bash -e

apt-get install -y gpsd gpsd-clients

### For manual build ###
#wget http://download.savannah.nongnu.org/releases/gpsd/gpsd-3.18.1.tar.gz
#tar -xzf gpsd-3.18.1.tar.gz
#rm gpsd-3.18.1.tar.gz
#cd gpsd-3.18.1
#scons && scons testregress && sudo scons udev-install
#cd ..
#rm -r gpsd-3.18.1

#echo 'START_DAEMON="false"' > /etc/default/gpsd
#echo 'USBAUTO="false"' >> /etc/default/gpsd
#echo 'DEVICES="/dev/ttyUSB0"' >> /etc/default/gpsd
#echo 'GPSD_OPTIONS=" -n "' >> /etc/default/gpsd

mkdir -p /etc/udev/rules.d/
cp $FILE_FOLDER/90-lys-gps.rules "/etc/udev/rules.d/"

mkdir -p /usr/local/bin/
cp $FILE_FOLDER/manage_gps.sh "/lib/udev"
chmod 0755 /lib/udev/manage_gps.sh

mkdir -p /etc/systemd/system
cp $FILE_FOLDER/lysgpsd@.service  "/etc/systemd/system"
chmod 0644 /etc/systemd/system/lysgpsd@.service
