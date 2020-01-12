#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -fvf /usr/share/applications/vim.desktop
rm -fvf /usr/share/applications/PyCrust.desktop
rm -fvf /usr/share/applications/XRCed.desktop
rm -rvf /home/user/Public /home/user/Templates /home/user/Videos /home/user/Desktop

apt-get clean
apt remove -y greybird-gtk-theme murrine-themes rpd-icons
apt -y autoremove
apt-get clean
