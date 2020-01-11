#!/bin/bash -e
rm -rvf /tmp/empty-cache46
rm -fvf /usr/share/applications/vim.desktop
rm -fvf /usr/share/applications/PyCrust.desktop
rm -fvf /usr/share/applications/XRCed.desktop
rm -rvf /home/pi/Public /home/pi/Templates /home/pi/Videos /home/pi/Desktop

apt-get clean
apt remove -y greybird-gtk-theme murrine-themes rpd-icons
apt -y autoremove
apt-get clean
