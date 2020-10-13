#!/bin/bash -e

## Needed to allow the service file start X
install  -v $FILE_FOLDER/Xwrapper.config "/etc/X11/"



if [ $LMOS == Raspbian ] ;then
	apt-get install -q -y xserver-xorg-video-fbturbo
fi

if [ $LMOS == Armbian ] ;then
	sudo apt-get -q -y install xserver-xorg-legacy	
fi

apt-get install -q -y \
gstreamer1.0-x gstreamer1.0-omx gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-alsa \
gstreamer1.0-libav alsa-utils libavahi-compat-libdnssd-dev git openbox \
xbacklight lxappearance gmrun xsettingsd xserver-xorg \
xinit libgtk2-perl pavucontrol cpanminus perl-base \
dialog lxterminal network-manager-gnome



install -d -o 1000 -g 1000 /home/user/.local
install -d -o 1000 -g 1000 /home/user/.local/share



# Openbox
install -d -o 1000 -g 1000 "/home/user/.config"
install -d -o 1000 -g 1000 "/home/user/.config/openbox"
install -o 1000 -g 1000  -v $FILE_FOLDER/autostart     "/home/user/.config/openbox/"



# Make some room for the rest of the build script
apt-get clean

## Install base desktop apps.
if [ $LMOS == Raspbian ] ;then
	apt-get install -y -q chromium-browser
else
	apt-get install -y -q chromium
fi

apt-get install -y -q pcmanfm lxterminal mousepad gpsbabel file-roller
