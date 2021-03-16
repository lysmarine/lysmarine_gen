#!/bin/bash -e

# See: https://github.com/martinber/predict

myArch=$(dpkg --print-architecture)

cd ~
wget -q -O - https://launchpad.net/ubuntu/+archive/primary/+files/predict_2.2.3-4build2_${myArch}.deb > predict_2.2.3-4build2_${myArch}.deb
wget -q -O - https://launchpad.net/ubuntu/+archive/primary/+files/predict-gsat_2.2.3-4build2_${myArch}.deb > predict-gsat_2.2.3-4build2_${myArch}.deb

sudo apt install libncurses5 libtinfo5 libforms2

sudo dpkg -i predict_2.2.3-4build2_${myArch}.deb predict-gsat_2.2.3-4build2_${myArch}.deb
