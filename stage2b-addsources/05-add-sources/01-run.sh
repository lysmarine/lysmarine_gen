#!/bin/bash -e
install files/nodesource.list "${ROOTFS_DIR}/etc/apt/sources.list.d/nodesource.list"
install files/opencpnsource.list "${ROOTFS_DIR}/etc/apt/sources.list.d/opencpnsource.list"

on_chroot << EOF

# opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C865EB40

# nodejs
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add

apt update
EOF
