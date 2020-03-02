#!/bin/bash -e

# Network manager
apt-get install -y -q network-manager make 



# Resolve lysmarine.local
apt-get install -y -q avahi-daemon 
echo -n 'lysmarine' > /etc/hostname
echo '127.0.1.1	lysmarine' >> /etc/hosts
echo '127.0.1.1	lysmarine.local' >> /etc/hosts



# Access Point management
apt-get install -y -q git util-linux procps hostapd iproute2 iw dnsmasq iptables
pushd ./stageCache 
	if [[ ! -f create_ap ]]; then 
		git clone --depth=1 https://github.com/oblique/create_ap
	fi
	pushd create_ap
		make install
	popd		
popd

cp $FILE_FOLDER/create_ap.conf /etc/
rm -rf create_ap



##  NetworkManager provide it's own wpa_supplicant, stop the others to avoid conflicts.  
systemctl disable dhcpcd.service
systemctl disable wpa_supplicant.service
systemctl disable hostapd.service


## Disable some useless networking serivces 
systemctl disable NetworkManager-wait-online.service # if we do not boot remote user it's not needed
systemctl disable ModemManager.service # for 2G/3G/4G
systemctl disable pppd-dns.service # For dial-up Internet LOL