#!/bin/bash -e

## Needed to allow the service file start X
install  -v $FILE_FOLDER/Xwrapper.config "/etc/X11/"

if [ $LMOS == Raspbian ]; then
  apt-get -q -y install xserver-xorg-video-fbturbo
fi

if [ $LMOS == Armbian ]; then
	apt-get -q -y install xserver-xorg-legacy
fi

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
install -o 1000 -g 1000 -d /home/user/.local/share/desktop-directories
install -o 1000 -g 1000 -d /home/user/.local/share/applications
install -o 1000 -g 1000 -d /home/user/.local/share/icons
install -o 1000 -g 1000 -d /home/user/.local/share/sounds

# Openbox
install -o 1000 -g 1000 -d /home/user/.config
install -o 1000 -g 1000 -d /home/user/.config/openbox

# Thunar file manager
install -o 1000 -g 1000 -d /home/user/.config/xfce4
install -o 1000 -g 1000 -d /home/user/.config/xfce4/xfconf
install -o 1000 -g 1000 -d /home/user/.config/xfce4/xfconf/xfce-perchannel-xml
install -o 1000 -g 1000 -v $FILE_FOLDER/thunar.xml /home/user/.config/xfce4/xfconf/xfce-perchannel-xml/

# Menus
install -o 1000 -g 1000 -d /home/user/.config/menus
install -o 1000 -g 1000 -v $FILE_FOLDER/gnome-applications.menu /home/user/.config/menus/gnome-applications.menu-orig
install -o 1000 -g 1000 -v $FILE_FOLDER/lysmarine-applications.menu /home/user/.config/menus/lysmarine-applications.menu-orig
install -o 1000 -g 1000 -v $FILE_FOLDER/lysmarine-applications.menu /home/user/.config/menus/gnome-applications.menu
install -o 1000 -g 1000 -v $FILE_FOLDER/navigation.directory /home/user/.local/share/desktop-directories/

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

apt-get install -y -q lxterminal gpsbabel file-roller

#apt-get install -y -q pcmanfm mousepad

apt-get install -y -q lxtask thunar
