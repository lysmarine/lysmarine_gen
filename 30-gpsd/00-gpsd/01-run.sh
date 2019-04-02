#!/bin/bash -e
on_chroot <<EOF
### For manual build ###
#wget http://download.savannah.nongnu.org/releases/gpsd/gpsd-3.18.1.tar.gz
#tar -xzf gpsd-3.18.1.tar.gz
#rm gpsd-3.18.1.tar.gz
#cd gpsd-3.18.1
#scons && scons testregress && sudo scons udev-install
#cd ..
#rm -r gpsd-3.18.1

#echo 'START_DAEMON="false"' > /etc/default/gpsd
#echo 'USBAUTO="false"' >> /etc/default/gpsd
#echo 'DEVICES="/dev/ttyUSB0"' >> /etc/default/gpsd
#echo 'GPSD_OPTIONS=" -n "' >> /etc/default/gpsd
EOF

install -d "${ROOTFS_DIR}/etc/udev/rules.d/"
install -v files/90-lys-gps.rules "${ROOTFS_DIR}/etc/udev/rules.d/"

install -d  "${ROOTFS_DIR}/usr/local/bin/"
install -v -m 0755 files/manage_gps.sh "${ROOTFS_DIR}/lib/udev"

install -d  "${ROOTFS_DIR}/etc/systemd/system"
install -v -m644 files/lysgpsd@.service  "${ROOTFS_DIR}/etc/systemd/system"
