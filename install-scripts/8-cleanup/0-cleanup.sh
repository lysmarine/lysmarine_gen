#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates /home/user/Videos /home/user/Desktop

apt-get clean

apt-get remove -y greybird-gtk-theme murrine-themes rpd-icons

apt-get -y autoremove
apt-get clean

## Menu cleanup 
rm -fv /usr/share/applications/vim.desktop
rm -fv /usr/share/applications/PyCrust.desktop
rm -fv /usr/share/applications/XRCed.desktop
rm -fv /usr/share/applications/x11vnc.desktop
rm -fv /usr/share/applications/org.gnome.FileRoller.desktop

