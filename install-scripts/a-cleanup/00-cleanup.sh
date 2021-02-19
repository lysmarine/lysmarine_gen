#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates 

apt-get clean

apt-get remove -y greybird-gtk-theme murrine-themes rpd-icons

apt-get -y autoremove
apt-get clean
npm cache clean --force

# remove python pip cache
rm -rf ~/.cache/pip

# remove all cache
rm -rf ~/.cache
rm -rf ~/.config
rm -rf ~/.npm
rm -rf ~/.wget*
rm -rf $(find /var/log/ -type f)

apt-get -q -y install --download-only avnav-update-plugin

date --rfc-3339=seconds > /etc/bbn-build
fake-hwclock save
