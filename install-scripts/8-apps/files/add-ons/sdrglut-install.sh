#!/bin/bash -e

# See: https://github.com/righthalfplane/SdrGlut

sudo apt-get -y install build-essential libsoapysdr0.6 libsoapysdr-dev libopenal-dev \
 libliquid-dev freeglut3 freeglut3-dev libalut0 libalut-dev librtaudio-dev
sudo apt-get -y install git
cd /home/user
git clone https://github.com/righthalfplane/SdrGlut.git
cd SdrGlut
make -f makefileRaspbian
