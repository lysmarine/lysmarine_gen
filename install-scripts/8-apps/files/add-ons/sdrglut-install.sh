#!/bin/bash -e

# See: https://github.com/righthalfplane/SdrGlut

myArch=$(dpkg --print-architecture)

sudo apt-get -y install build-essential libsoapysdr0.6 libsoapysdr-dev libopenal-dev \
 libliquid-dev freeglut3 freeglut3-dev libalut0 libalut-dev librtaudio-dev
sudo apt-get -y install git
cd /home/user
rm -rf SdrGlut || true
if [ "armhf" == "$myArch" ] ; then
  git clone https://github.com/righthalfplane/SdrGlut
else
  git clone https://github.com/bareboat-necessities/SdrGlut
fi
cd SdrGlut
make -f makefileRaspbian

# to run
# ./sdrglut.x
