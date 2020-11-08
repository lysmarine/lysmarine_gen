#!/bin/bash -e

adduser mopidy video
adduser mopidy audio

# Install Mopidy and all dependencies:
apt-get -y install mopidy mopidy-mpd mopidy-spotify mopidy-tunein python3-spotify xdotool

# Install some needed packages
python3 -m pip install mem systems

# Install Mopidy MusicBox Web Client:
python3 -m pip install Mopidy-MusicBox-Webclient

# Install YouTube support
python3 -m pip install --pre Mopidy-YouTube

# Enable mopidy service
systemctl enable mopidy
