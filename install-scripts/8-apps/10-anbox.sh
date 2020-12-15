#!/bin/bash -e

apt-get -q -y install anbox
apt-get -q -y install android-tools-adb git curl unzip
apt-get -q -y install dkms
apt-get -q -y install linux-headers-generic

cd ~
git clone https://github.com/anbox/anbox-modules.git

pushd anbox-modules
  install -v -m 0644 anbox.conf "/etc/modules-load.d/"
  install -v -m 0644  99-anbox.rules "/lib/udev/rules.d/"
  cp -rT ashmem /usr/src/anbox-ashmem-1
  cp -rT binder /usr/src/anbox-binder-1
  dkms install anbox-ashmem/1
  dkms install anbox-binder/1
popd

apt-get -q -y install software-properties-common
add-apt-repository ppa:morphis/anbox-support
apt update
apt-get -q -y install linux-headers-generic anbox-modules-dkms

