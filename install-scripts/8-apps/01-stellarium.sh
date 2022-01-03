#!/bin/bash -e

apt-get clean

apt-get -y -q install geographiclib-tools \
   libqt5concurrent5 \
   libqt5core5a \
   libqt5gui5 \
   libqt5svg5 \
   libqt5opengl5 \
   libqt5multimedia5 \
   libqt5multimediawidgets5 \
   libqt5network5 \
   libqt5positioning5 \
   libqt5printsupport5 \
   libqt5script5 \
   libqt5serialport5 \
   libqt5widgets5

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
