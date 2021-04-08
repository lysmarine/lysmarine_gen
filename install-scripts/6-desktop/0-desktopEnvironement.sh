#!/bin/bash -e

## Needed to allow the service file start X
install  -v $FILE_FOLDER/Xwrapper.config "/etc/X11/"

## Xorg server
apt-get -yq --no-install-recommends install xserver-xorg-legacy xserver-xorg xinit x11-xserver-utils xinput

## Rpi specific packages
apt-get install -yq --no-install-recommends xserver-xorg-video-fbdev xserver-xorg-video-fbturbo gldriver-test \
	&& apt-get remove -y xserver-xorg-video-all xserver-xorg-video-amdgpu xserver-xorg-video-ati xserver-xorg-video-nouveau xserver-xorg-video-radeon xserver-xorg-video-vesa \
	|| true

## Base desktop Env
apt-get install -yq --no-install-recommends \
	evdev-rce \
	alsa-utils pavucontrol pulseaudio rtkit dbus-user-session pulseaudio-module-bluetooth \
	sakura \
	network-manager-gnome mobile-broadband-provider-info iso-codes \
	awesome awesome-extra gir1.2-gtk-3.0 rlwrap # fixme not sure if rlwrap is really needed

# Apps
apt-get install -yq --no-install-recommends \
	mirage \
	gpsbabel gpsbabel-doc \
	mousepad \
	pcmanfm gvfs-backends gvfs-fuse  file-roller \
	vlc nautic
apt-get install -yq chromium

## Rpi specific packages
apt-get install -yq --no-install-recommends piclone pigpio libturbojpeg0 raspi-copies-and-fills || true

apt-get install -yq rpi-chromium-mods || apt-get install -yq chromium-sandbox

#sed -i 's/"first_run_tabs":["*"]/"first_run_tabs":["https://lysmarine.org"]/' /etc/chromium/master_preferences

# "first_run_tabs":["https://welcome.raspberrypi.org/raspberry-pi-os?id=UNIDENTIFIED"]
# rm /etc/chromium/master_preferences

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
