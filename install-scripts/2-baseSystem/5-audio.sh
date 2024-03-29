#! /bin/bash
apt-get -y -q install pulseaudio

apt-get -yq install \
	gstreamer1.0-alsa \
	gstreamer1.0-libav \
	gstreamer1.0-omx-rpi-config \
	gstreamer1.0-omx-rpi  \
	gstreamer1.0-omx \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-plugins-base \
	gstreamer1.0-plugins-good \
	gstreamer1.0-x

## Give volume and device management capabilities to the user user.
usermod -a -G audio user
