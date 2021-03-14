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

usermod -a -G audio user
echo "set-default-source alsa_output.platform-bcm2835_audio.analog-mono.2.monitor" >> /etc/pulse/default.pa
#echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1" >> /etc/pulse/default.pa