#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates /home/user/Videos /home/user/Desktop

dpkg --remove khmerconverter mlterm debian-reference-common greybird-gtk-theme murrine-themes rpd-icons || true

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