#!/bin/bash -e

## Needed to allow the service file start X
install  -v $FILE_FOLDER/Xwrapper.config "/etc/X11/"

apt-get -q -y install xserver-xorg-video-fbturbo

# Install touchscreen drivers
apt-get -q -y install xserver-xorg-input-libinput
apt-get -q -y install xinput libinput-tools
apt-get -q -y install xinput-calibrator

apt-get install -q -y budgie-desktop

apt-get install -q -y \
gstreamer1.0-x gstreamer1.0-omx gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-alsa \
gstreamer1.0-libav alsa-utils libavahi-compat-libdnssd-dev git openbox \
xbacklight lxappearance gmrun xsettingsd xserver-xorg \
xinit libgtk2-perl cpanminus perl-base \
dialog lxterminal network-manager-gnome

install -o 1000 -g 1000 -d /home/user/.local
install -o 1000 -g 1000 -d /home/user/.local/share

# Openbox
install -o 1000 -g 1000 -d "/home/user/.config"
install -o 1000 -g 1000 -d "/home/user/.config/openbox"
install -o 1000 -g 1000 -v $FILE_FOLDER/autostart  "/home/user/.config/openbox/"

# Make some room for the rest of the build script
apt-get clean

## Install base desktop apps.
if [ $LMOS == Raspbian ]; then
	apt-get install -y -q chromium-browser
else
	apt-get install -y -q chromium
fi

# Adobe Flash Player. Copyright 1996-2015. Adobe Systems Incorporated. All Rights Reserved.
DEBIAN_FRONTEND=noniterractive apt-get -o Dpkg::Options:=="--force-confnew" -q -y install rpi-chromium-mods

apt-get install -y -q pcmanfm lxterminal mousepad gpsbabel file-roller
