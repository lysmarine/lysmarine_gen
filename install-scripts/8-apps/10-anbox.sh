#!/bin/bash -e

apt-get -q -y install android-tools-adb git curl unzip
apt-get -q -y install dkms
apt-get -q -y install raspberrypi-kernel-headers

cd ~
git clone https://github.com/anbox/anbox-modules.git

pushd anbox-modules
  install -v -m 0644 anbox.conf "/etc/modules-load.d/"
  install -v -m 0644 99-anbox.rules "/lib/udev/rules.d/"
  cp -rT ashmem /usr/src/anbox-ashmem-1
  cp -rT binder /usr/src/anbox-binder-1
  dkms install anbox-ashmem/1
  dkms install anbox-binder/1
popd

apt-get -q -y install anbox

#apt-get -q -y install software-properties-common

#install -m0644 -v $FILE_FOLDER/anbox.list "/etc/apt/sources.list.d/"
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 21C6044A875B67B7 # anbox

#apt-get -q -y install raspberrypi-kernel-headers anbox-modules-dkms

