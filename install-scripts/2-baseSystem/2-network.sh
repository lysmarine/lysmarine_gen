#!/bin/bash -e

## Network manager
apt-get install -y -q network-manager make

## Resolve lysmarine.local
apt-get install -y -q avahi-daemon
install -v $FILE_FOLDER/hostname "/etc/"
sed -i '/raspberrypi/d' /etc/hosts
cat $FILE_FOLDER/hosts >> /etc/hosts

### By default, network manager will connect as a preconfigured hotspot.
install -m0600 -v $FILE_FOLDER/lysmarine-hotspot.nmconnection "/etc/NetworkManager/system-connections/"
systemctl disable dnsmasq

##  NetworkManager provide it's own wpa_supplicant, stop the others to avoid conflicts.
if service --status-all | grep -Fq 'dhcpcd'; then
	systemctl disable dhcpcd.service
fi
systemctl disable wpa_supplicant.service

## Disable some useless networking services.
systemctl disable NetworkManager-wait-online.service # If we do not boot remote user over the network this is not needed
systemctl disable ModemManager.service # for 2G/3G/4G
systemctl disable pppd-dns.service # For dial-up Internet

#FIXME This is a dirty hack to avoid conflict with NetworkManager. A better solution is probable available in this link link http://downloads.fars-robotics.net/
echo "" > /etc/wpa_supplicant/wpa_supplicant.conf
