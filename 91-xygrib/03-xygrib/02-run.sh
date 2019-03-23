#!/bin/bash -e
install -d "${ROOTFS_DIR}/usr/share/applications/"
install files/XyGrib.desktop "${ROOTFS_DIR}/usr/share/applications/"

install -d "${ROOTFS_DIR}/usr/local/share/openGribs/XyGrib/data/img/"
install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.local/share/applications/openGrib/XyGrib/data/"


on_chroot << EOF

wget https://github.com/opengribs/XyGrib/archive/v1.2.4.tar.gz
tar xf v1.2.4.tar.gz
rm v1.2.4.tar.gz
mv -f XyGrib-1.2.4 XyGrib

cd XyGrib
mkdir -p build
cd build

cmake ..
make
make install

cd /
rm -rf /XyGrib

EOF

install files/XyGrib -m755 "${ROOTFS_DIR}/bin/"
install files/XyGrib.desktop "${ROOTFS_DIR}/usr/share/applications"
install files/logo_grib.jpg "${ROOTFS_DIR}/usr/local/share/openGribs/XyGrib/data/img/"
install -d -o 1000 -g 1000   "${ROOTFS_DIR}/home/pi/.local/share/icons/"

install -o 1000 -g 1000 files/logo_grib.png "${ROOTFS_DIR}/home/pi/.local/share/icons/"
