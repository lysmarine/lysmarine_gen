#!/bin/bash -e

# See: https://github.com/martinber/noaa-apt

mkdir ~/noaa-apt
cd ~/noaa-apt
wget https://github.com/martinber/noaa-apt/releases/download/v1.3.0/noaa-apt-1.3.0-armv7-linux-gnueabihf.zip
unzip noaa-apt-1.3.0-armv7-linux-gnueabihf.zip
