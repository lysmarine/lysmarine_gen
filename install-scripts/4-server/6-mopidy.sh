#!/bin/bash -e
# Strongly Inspired by https://github.com/bareboat-necessities/lysmarine_gen/blob/master/install-scripts/4-server/06-mopidy.sh
apt-get -yq --no-install-recommends install mopidy
apt-get -yq --no-install-recommends install mopidy-mpd mopidy-tunein xdotool

# Install some needed packages
python3 -m pip install systems

# Install Mopidy MusicBox Web Client:
python3 -m pip install Mopidy-MusicBox-Webclient

install -m 644 $FILE_FOLDER/mopidy.conf "/etc/mopidy/"

rm -rf ~/.cache/pip