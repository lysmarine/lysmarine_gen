#!/bin/bash -e

apt-get install -y -q opencpn

apt-get install -y -q opencpn-plugin-celestial opencpn-plugin-launcher 

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"

apt-get install -y -q oernc-pi

mkdir oe-tmp
cd oe-tmp
wget https://dl.cloudsmith.io/public/david-register/ocpn-plugins-unstable/raw/names/oesenc-ubuntu-arm64-18.04-tarball/versions/4.2.18.2.0.c89a5c4/oesenc_pi-4.2.18.2-0_ubuntu-arm64-18.04.tar.gz
gzip -cd oesenc_pi-4.2.18.2-0_ubuntu-arm64-18.04.tar.gz | tar xvf -
cd oesenc_pi-4.2.18.2-0_ubuntu-arm64-18.04
cp -r /usr /
cp -r /etc /
cd ../../
rm -rf oe-tmp

mkdir s63-tmp
cd s63-tmp
wget https://dl.cloudsmith.io/public/david-register/ocpn-plugins-unstable/raw/names/s63-ubuntu-arm64-18.04-tarball/versions/1.17.1.0.bcaad82/s63_pi-1.17.1-0_ubuntu-arm64-18.04.tar.gz
gzip -cd s63_pi-1.17.1-0_ubuntu-arm64-18.04.tar.gz | tar xvf -
cd s63_pi-1.17.1-0_ubuntu-arm64-18.04
cp -r /usr /
cd ../../
rm -rf s63-tmp
