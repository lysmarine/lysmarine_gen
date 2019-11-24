#!/bin/bash -e

apt-get install -y \
gstreamer1.0-x gstreamer1.0-omx gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-alsa gstreamer1.0-libav alsa-utils \
nodejs libavahi-compat-libdnssd-dev  git \
pcmanfm feh \
openbox xbacklight lxappearance gmrun xdotool xsettingsd gnome-themes-standard \
xserver-xorg xinit xserver-xorg-video-fbdev \
xserver-xorg-video-fbturbo \
libgtk2-perl \
leafpad gsimplecal \
pavucontrol \
cpanminus perl-base dialog \
lxterminal \
luakit \
conky-all


apt-get install -y chromium-browser


install -d -o pi -g pi /home/pi/.local
install -d -o pi -g pi /home/pi/.local/share

chown pi:pi /home/pi/.local
chown pi:pi /home/pi/.local/share # luakit change it to root So we must give it back to pi.

# Openbox 
install -o 1000 -g 1000  -v $FILE_FOLDER/autostart     "/home/pi/.config/openbox/"
