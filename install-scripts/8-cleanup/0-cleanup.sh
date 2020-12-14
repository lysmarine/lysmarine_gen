#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates /home/user/Videos /home/user/Desktop

apt-get -yq remove --auto-remove khmerconverter  || true
apt-get -yq remove --auto-remove mlterm || true
apt-get -yq remove --auto-remove debian-reference-common || true
apt-get -yq remove --auto-remove greybird-gtk-theme  || true
apt-get -yq remove --auto-remove murrine-themes || true
apt-get -yq remove --auto-remove rpd-icons || true


apt-get -y autoremove
apt-get clean

## Menu cleanup 
rm -fv /usr/share/applications/vim.desktop
rm -fv /usr/share/applications/PyCrust.desktop
rm -fv /usr/share/applications/XRCed.desktop
rm -fv /usr/share/applications/opencpn.desktop
rm -fv /usr/share/applications/x11vnc.desktop
rm -fv /usr/share/applications/org.gnome.FileRoller.desktop
rm -fv /usr/local/share/applications/opencpn.desktop #for amd64 that need a manual builds