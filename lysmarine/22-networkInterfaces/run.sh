#!/bin/bash -e

# network manager
apt-get install -y network-manager network-manager-gnome
apt-get install -y util-linux procps hostapd iproute2 iw dnsmasq iptables

#acces point
git clone --depth=1 https://github.com/oblique/create_ap
cd create_ap
make install
cd ../

cp $FILE_FOLDER/create_ap.conf /etc/
rm -rf create_ap
