#!/bin/bash -e

## Needed to allow the service file start X
install  -v $FILE_FOLDER/Xwrapper.config "/etc/X11/"

if [ $LMOS == Armbian ] ;then
	sudo apt-get -q -y install xserver-xorg-legacy	
fi

sudo apt-get -q -y install xserver-xorg-legacy
apt-get install -yq \
	xserver-xorg xinit evdev-rce awesome alsa-utils \
 	servicemanager pavucontrol network-manager-gnome \
	chromium sakura mousepad file-roller gpsbabel mirage rpi-chromium-mods
apt-get install -yq --no-install-recommends gvfs-backends gvfs-fuse pcmanfm 

apt-get purge --auto-remove -yq system-config-printer # chromium install cups but we don't need it.
apt-get purge --auto-remove -yq gnome-keyring # chromium and others install a keyring service but we don't need it

install -d -o 1000 -g 1000 /home/user/.local/share/
install -d -o 1000 -g 1000 "/home/user/.config/"

## Autostart script
install -m0744 -o 1000 -g 1000 $FILE_FOLDER/autostart "/home/user/.config/"

## Make some room for the rest of the build script
apt-get clean

## Force polkit agent to start with openbox (this is needed for nm-applet hotspot configuration)
sed -i '/^OnlyShowIn=/ s/$/GNOME;/' /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop

## To use the same theme for Qt/KDE applications and GTK applications, and fix missing indicators
echo XDG_CURRENT_DESKTOP=Unity >> /etc/environment
echo QT_QPA_PLATFORMTHEME=gtk2 >> /etc/environment
