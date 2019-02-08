#!/bin/bash -e
install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/.config/obmenu-generator"
on_chroot << EOF
cpanm Linux::DesktopFiles Data::Dump

git clone -q git://github.com/trizen/obmenu-generator
cp -vf ./obmenu-generator/schema.pl /home/pi/.config/obmenu-generator/schema.pl

chown -R pi:pi /home/pi/.config/obmenu-generator/schema.pl
cp -vf obmenu-generator/obmenu-generator /usr/bin
chmod -v a+x /usr/bin/obmenu-generator
su pi -c '/usr/bin/obmenu-generator -p '
rm -rv obmenu-generator
EOF




install -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/applications/"
install -o 1000 -g 1000  -v files/open-openbox-menu.desktop    "${ROOTFS_DIR}/home/pi/.local/share/applications/"
