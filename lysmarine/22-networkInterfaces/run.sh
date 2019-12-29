#!/bin/bash -e

# network manager
apt-get install -y network-manager
apt-get install -y git util-linux procps hostapd iproute2 iw dnsmasq iptables

#acces point
git clone --depth=1 https://github.com/oblique/create_ap
pushd create_ap
make install
popd

cp $FILE_FOLDER/create_ap.conf /etc/
rm -rf create_ap

systemctl disable dhcpcd.service
systemctl disable wpa_supplicant.service
