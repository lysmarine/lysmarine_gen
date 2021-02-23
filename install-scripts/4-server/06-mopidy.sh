#!/bin/bash -e

# Install Mopidy and all dependencies:
#apt-get -y install mopidy mopidy-mpd mopidy-spotify mopidy-tunein libspotify-dev xdotool

apt-get -y --no-install-recommends install mopidy
apt-get -y --no-install-recommends install mopidy-mpd mopidy-tunein xdotool

adduser mopidy video
adduser mopidy audio

# Install some needed packages
pip3 install install systems

# Install Mopidy MusicBox Web Client:
pip3 install install Mopidy-MusicBox-Webclient

# Install YouTube support
apt-get -y install gstreamer1.0-plugins-bad
#pip3 install install --pre Mopidy-YouTube
pip3 install install https://github.com/natumbri/mopidy-youtube/archive/develop.zip

pip3 install --upgrade requests

# Enable mopidy service
systemctl enable mopidy

install -m 644 $FILE_FOLDER/.asoundrc "/home/user/"
install -m 644 $FILE_FOLDER/mopidy.conf "/etc/mopidy/"
install -m 755 -d -o mopidy -g audio "/var/lib/mopidy/m3u"
install -m 644 -o mopidy -g audio $FILE_FOLDER/BBN-Playlist.m3u8 "/var/lib/mopidy/m3u/"

rm -rf ~/.cache/pip
