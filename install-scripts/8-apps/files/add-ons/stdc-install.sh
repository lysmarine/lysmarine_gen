#!/bin/bash -e

# See: https://github.com/cropinghigh/stdcdec

cd /usr/local/share
cd inmarsatc
sudo mkdir -p build && cd build
sudo cmake ..
sudo make
sudo make install
sudo make clean
cd ../../

cd stdcdec
sudo mkdir -p build && cd build
sudo cmake ..
sudo make
sudo make install
sudo make clean
cd ../../
