#!/bin/bash -e

touch /etc/X11/Xwrapper.config



apt-get install -q -y \
gstreamer1.0-x gstreamer1.0-omx gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
gstreamer1.0-plugins-bad gstreamer1.0-alsa gstreamer1.0-libav alsa-utils \
libavahi-compat-libdnssd-dev git openbox xbacklight lxappearance gmrun xdotool \
xsettingsd gnome-themes-standard xserver-xorg xinit xserver-xorg-video-fbdev \
xserver-xorg-video-fbturbo libgtk2-perl \
gsimplecal pavucontrol cpanminus perl-base dialog \
lxterminal network-manager-gnome



install -d -o 1000 -g 1000 /home/pi/.local
install -d -o 1000 -g 1000 /home/pi/.local/share



# Openbox
install -d -o 1000 -g 1000 "/home/pi/.config"
install -d -o 1000 -g 1000 "/home/pi/.config/openbox"
install -o 1000 -g 1000  -v $FILE_FOLDER/autostart     "/home/pi/.config/openbox/"
