#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -fvf /usr/share/applications/vim.desktop
rm -fvf /usr/share/applications/PyCrust.desktop
rm -fvf /usr/share/applications/XRCed.desktop
rm -rvf /home/user/Public /home/user/Templates /home/user/Videos /home/user/Desktop

apt-get clean

if [ $LMBUILD == raspbian ] ;then
	apt remove -y greybird-gtk-theme murrine-themes rpd-icons
fi

apt -y autoremove
apt-get clean
