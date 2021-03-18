#!/bin/bash -e

# Install Mopidy and all dependencies:
apt-get -yq --no-install-recommends install mopidy mopidy-mpd mopidy-tunein

usermod -a -G video mopidy

# Install Mopidy MusicBox Web Client:
pip3 install systems Mopidy-MusicBox-Webclient

# Install YouTube support
apt-get -y install gstreamer1.0-plugins-bad
pip3 install https://github.com/natumbri/mopidy-youtube/archive/develop.zip
pip3 install --upgrade requests

# Enable Mopidy service
systemctl disable mopidy

install -m 644 $FILE_FOLDER/mopidy.conf "/etc/mopidy/"

rm -rf ~/.cache/pip