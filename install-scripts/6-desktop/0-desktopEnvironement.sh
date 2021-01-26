#!/bin/bash -e

## Needed to allow the service file start X
install  -v $FILE_FOLDER/Xwrapper.config "/etc/X11/"

if [ $LMOS == Raspbian ] ;then
	apt-get install -q -y xserver-xorg-video-fbturbo
fi

if [ $LMOS == Armbian ] ;then
	sudo apt-get -q -y install xserver-xorg-legacy	
fi

#apt-get install -yq \
#gstreamer1.0-x gstreamer1.0-omx gstreamer1.0-plugins-base \
#gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-alsa \
#gstreamer1.0-libav alsa-utils libavahi-compat-libdnssd-dev git openbox \
#xbacklight lxappearance xsettingsd xserver-xorg \
#xinit libgtk2-perl pavucontrol cpanminus perl-base \
#dialog lxterminal network-manager-gnome  servicemanager \
#chromium pcmanfm lxterminal mousepad gpsbabel

apt-get install -yq \
	xserver-xorg evdev-rce awesome \
 	servicemanager pavucontrol network-manager-gnome\
	chromium sakura mousepad file-roller pcmanfm \

## DE config files
install -d -o 1000 -g 1000 /home/user/.local/share/

install -d -o 1000 -g 1000 "/home/user/.config/"

cp -r $FILE_FOLDER/awesome "/home/user/.config/"
chown -R 1000:1000 "/home/user/.config/"

## Make some room for the rest of the build script
apt-get clean

## Force polkit agent to start with openbox (this is needed for nm-applet hotspot configuration)
sed -i '/^OnlyShowIn=/ s/$/GNOME;/' /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop

echo XDG_CURRENT_DESKTOP=Unity >> /etc/environment
echo QT_QPA_PLATFORMTHEME=gtk2 >> /etc/environment
