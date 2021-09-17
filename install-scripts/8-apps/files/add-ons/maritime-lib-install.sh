#!/bin/bash -e

# A collection of free useful sailing & maritime related documents
#
# https://www.reddit.com/r/sailing/comments/3hwagp/a_collection_of_free_useful_sailing_maritime/?utm_source=share&utm_medium=ios_app&utm_name=iossmf
#
# (04.01.2021): Here's an updated link: https://drive.google.com/file/d/12eicYVtI2EsfG3teeSBy3j3-1A7DNq9P/view?usp=sharing

PUB_URL="https://drive.google.com/uc?id=12eicYVtI2EsfG3teeSBy3j3-1A7DNq9P&export=download"
CUR_DIR="$(pwd)"

mkdir -p ~/Documents/Maritime/ && cd ~/Documents/Maritime/

# script to download Google Drive files from command line
# not guaranteed to work indefinitely
# taken from Stack Overflow answer:
# http://stackoverflow.com/a/38937732/7002068

gURL=$PUB_URL
# match more than 26 word characters
ggID=$(echo "$gURL" | egrep -o '(\w|-){26,}')

ggURL='https://drive.google.com/uc?export=download'

curl -sc /tmp/gcokie "${ggURL}&id=${ggID}" >/dev/null
getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)"

cmd='curl --insecure -C - -LOJb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}"'
echo -e "Downloading from "$gURL"...\n"
eval $cmd

# Public domain documents created by US federal government employee as part of their official duties
unzip -jo OnboardComputerSystemDocuments.zip \
 "Documents/American Practical Navigator*" \
 "Documents/Atlas of Pilot Charts*" \
 "Documents/Distance Between Ports*" \
 "Documents/*World Map of Time Zones*" \
 "Documents/International Code of Signals*" \
 "Documents/Navigation Rules*" \
 "Documents/Radar Navigation and Maneuvering*" \
 "Documents/Sailing Directions Enroute*" \
 "Documents/Sailing Directions Planning Guides*" \
 "Documents/U.S. Chart No. 1*" \
 "Documents/World Port Index*"

rm OnboardComputerSystemDocuments.zip
cd "$CUR_DIR"
