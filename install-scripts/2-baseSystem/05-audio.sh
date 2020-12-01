#!/bin/bash -e

apt-get -y -q install pulseaudio
usermod -a -G audio user

echo "set-default-source alsa_output.platform-bcm2835_audio.analog-mono.2.monitor" >> /etc/pulse/default.pa
