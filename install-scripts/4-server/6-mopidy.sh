#!/bin/bash -e
# Strongly Inspired by https://github.com/bareboat-necessities/lysmarine_gen/blob/master/install-scripts/4-server/06-mopidy.sh

apt-get -yq --no-install-recommends install mopidy mopidy-mpd mopidy-tunein xdotool python3-pip
usermod -a -G video mopidy

pip3 install systems Mopidy-MusicBox-Webclient

install -m 644 $FILE_FOLDER/mopidy.conf "/etc/mopidy/"

rm -rf ~/.cache/pip