#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates /home/user/Videos /home/user/Desktop


apt-get clean

if [ $LMBUILD == raspbian ] ;then
	apt-get remove -y greybird-gtk-theme murrine-themes rpd-icons 
#	apt purge -y gnome-accessibility-themes
#   apt purge -y gnome-icon-theme hicolor-icon-theme 
fi

apt -y autoremove
apt-get clean

# Menu cleanup 
rm -fv /usr/share/applications/vim.desktop
rm -fv /usr/share/applications/PyCrust.desktop
rm -fv /usr/share/applications/XRCed.desktop
rm -fv /usr/share/applications/opencpn.desktop
rm -fv /usr/share/applications/x11vnc.desktop
rm -fv /usr/share/applications/org.gnome.FileRoller.desktop
rm -fv /usr/local/share/applications/opencpn.desktop #for amd64 that need a manual build