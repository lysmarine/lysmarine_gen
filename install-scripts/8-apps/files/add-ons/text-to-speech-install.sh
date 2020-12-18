#!/bin/bash -e

# See https://pypi.org/project/ttspico/

wget -q -O- https://ftp-master.debian.org/keys/release-10.asc | sudo apt-key add -

echo "deb http://deb.debian.org/debian buster non-free" | sudo tee -a "/etc/apt/sources.list.d/non-free.list"

sudo apt update
sudo apt-get -y install libttspico-utils
sudo apt-get -y install sox
