#!/bin/bash -e

apt-get install -y git cmake build-essential qt5-default qttools5-dev qtbase5-dev libqt5widgets5 libpng-dev libopenjp2-7-dev libnova-dev libproj-dev zlib1g-dev libbz2-dev

install -d "/usr/share/applications/"
install $FILE_FOLDER/XyGrib.desktop "/usr/share/applications/"

install -d "/usr/local/share/openGribs/XyGrib/data/img/"
install -d -o 1000 -g 1000 "$FILE_FOLDER/home/pi/.local/share/applications/openGrib/XyGrib/data/"



wget https://github.com/opengribs/XyGrib/archive/v1.2.6.tar.gz
tar xf v1.2.6.tar.gz
rm v1.2.6.tar.gz
mv -f XyGrib-1.2.6 XyGrib

cd XyGrib
mkdir -p build
cd build

cmake ..
make
make install

cd ../../
rm -rf /XyGrib


install $FILE_FOLDER/XyGrib -m755 "/usr/local/bin/"
install $FILE_FOLDER/XyGrib.desktop "/usr/share/applications"
#install files/logo_grib.jpg "${ROOTFS_DIR}/usr/local/share/openGribs/XyGrib/data/img/"
#install -d -o 1000 -g 1000   "${ROOTFS_DIR}/home/pi/.local/share/icons/"

 install -o 1000 -g 1000 $FILE_FOLDER/logo_grib.png "/usr/share/icons/"
