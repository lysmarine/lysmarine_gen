#!/bin/bash -e

## Network manager
apt-get install -yq network-manager

## Resolve lysmarine.local
apt-get install -y -q avahi-daemon
install -v $FILE_FOLDER/hostname "/etc/"
sed -i '/raspberrypi/d' /etc/hosts
cat $FILE_FOLDER/hosts >> /etc/hosts

### By default, network manager will connect as a preconfigured hotspot.
install -m0600 -v $FILE_FOLDER/lysmarine-hotspot.nmconnection "/etc/NetworkManager/system-connections/"

## Disable some useless networking services.
systemctl disable NetworkManager-wait-online.service || true # If we do not boot remote user over the network this is not needed
systemctl disable ModemManager.service || true # for 2G/3G/4G
systemctl disable pppd-dns.service || true # For dial-up Internet

