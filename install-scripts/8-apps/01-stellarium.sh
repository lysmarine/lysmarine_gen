#!/bin/bash -e

apt-get clean

apt-get -y -q install geographiclib-tools

wget https://launchpad.net/~stellarium/+archive/ubuntu/stellarium-releases/+files/stellarium_0.21.2-upstream1~ubuntu18.04.1_${LMARCH}.deb
wget https://launchpad.net/~stellarium/+archive/ubuntu/stellarium-releases/+files/stellarium-data_0.21.2-upstream1~ubuntu18.04.1_all.deb

dpkg -i stellarium_0.21.2-upstream1~ubuntu18.04.1_${LMARCH}.deb stellarium-data_0.21.2-upstream1~ubuntu18.04.1_all.deb
rm -f stellarium_0.21.2-upstream1~ubuntu18.04.1_${LMARCH}.deb stellarium-data_0.21.2-upstream1~ubuntu18.04.1_all.deb

install -d -o 1000 -g 1000 -m 0755 "/home/user/.stellarium"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/stellarium-config.ini "/home/user/.stellarium/config.ini"

install -v -m 0644 $FILE_FOLDER/stellarium.desktop /usr/share/applications/
install -v -m 0755 $FILE_FOLDER/stellarium-augmented.sh /usr/local/bin/stellarium-augmented

geographiclib-get-magnetic all

apt-get clean
