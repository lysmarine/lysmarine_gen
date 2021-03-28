#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates /home/user/Videos /home/user/Desktop

## Remove unused package
apt-get purge --auto-remove -yq gnome-keyring # chromium and others install a keyring service but we don't need it
apt-get -yq remove --auto-remove khmerconverter  || true
apt-get -yq remove --auto-remove mlterm || true
apt-get -yq remove --auto-remove debian-reference-common || true
apt-get -yq remove --auto-remove greybird-gtk-theme  || true
apt-get -yq remove --auto-remove murrine-themes || true
apt-get -yq remove --auto-remove rpd-icons || true
apt-get -yq remove --auto-remove yelp || true
apt-get -yq remove --auto-remove gnome-icon-theme || true
apt-get -y autoremove
apt-get clean

## clean cache of others package managers
# pip3 cache purge   # require pip version > 20.1
rm -rf /root/.cache/pip
npm cache clean --force || true
su signalk -c "npm cache clean --force"

## Remove others cache
rm -rf /root/.cache/electron
rm -rf /root/.wget*