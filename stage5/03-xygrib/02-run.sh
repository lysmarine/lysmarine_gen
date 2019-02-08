#!/bin/bash -e
install -d "${ROOTFS_DIR}/usr/share/applications/"
install files/XyGrib.desktop "${ROOTFS_DIR}/usr/share/applications/"

install -d "${ROOTFS_DIR}/usr/local/share/openGribs/XyGrib/data/img/"
install files/logo_grib.jpg "${ROOTFS_DIR}/usr/local/share/openGribs/XyGrib/data/img/"

on_chroot << EOF
# For Ubuntu/Debian build and install new version of XyGrib from archive file on https://opengribbs.org
# DomH, 28/08/2018 (modified 21/08/2018, 03/10/2018)
# Based of the script found at https://github.com/dominiquehausser/XyGrib/releases/download/v1.1.1/Xygrib_download_build.sh


# Requested parameters
# Local folders
DefaultInstallDir="/"
AppDir="/usr/local/bin"
DataDir="/usr/local/share/openGribs/XyGrib"
DownloadDir=$(pwd)



wget https://github.com/opengribs/XyGrib/archive/v1.2.4.tar.gz
tar xf v1.2.4.tar.gz
mv XyGrib-1.2.4 XyGribSrc
# create build directory
mkdir -p XyGribSrc/build

# Build and install XyGrib new version
cd XyGribSrc/build
cmake -DCMAKE_INSTALL_PREFIX= ..
echo "==cmakedone============="

make 1>Xygrib.std 2>Xygrib.err
echo "==============="
cat Xygrib.err
echo "==============="

echo "make Done, now running make install "

make install
rm -rf /usr/local/bin/XyGrib
mv /XyGrib/XyGrib /usr/local/bin/
mkdir -p /usr/local/share/openGribs/XyGrib
rm -rf /usr/local/share/openGribs/XyGrib/data
mv /XyGrib/data /usr/local/bin/
echo "Successfull new build installed"

      mkdir -p /home/pi/.local/share/applications/openGrib/XyGrib/data

#mv /usr/local/share/openGrib/XyGrib/data/colors /home/pi/.local/share/applications/openGrib/XyGrib/data
#ln -s /home/pi/.local/share/applications/openGrib/XyGrib/data/colors /usr/local/share/openGribs/XyGrib/data/colors
rm -rf /XyGrib
rm -rf /XyGribSrc
rm -rf /XyGribv1.2.4.tar.gz

echo "Done building XyGrib"
EOF
