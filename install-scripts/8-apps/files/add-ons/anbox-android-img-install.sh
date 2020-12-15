#!/bin/bash -e

sudo apt-get -q -y install android-tools-adb git curl unzip
sudo apt-get -q -y install dkms
sudo apt-get -q -y install raspberrypi-kernel-headers

cd ~
git clone https://github.com/anbox/anbox-modules.git

pushd anbox-modules
  sudo install -v -m 0644 anbox.conf "/etc/modules-load.d/"
  sudo install -v -m 0644 99-anbox.rules "/lib/udev/rules.d/"
  sudo cp -rT ashmem /usr/src/anbox-ashmem-1
  sudo cp -rT binder /usr/src/anbox-binder-1
  sudo dkms install anbox-ashmem/1
  sudo dkms install anbox-binder/1
popd

sudo apt-get -q -y install anbox

#sudo apt-get -q -y install software-properties-common
#sudo install -m0644 -v $FILE_FOLDER/anbox.list "/etc/apt/sources.list.d/"
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 21C6044A875B67B7 # anbox
#sudo apt-get -q -y install raspberrypi-kernel-headers anbox-modules-dkms

sudo bash -c 'curl https://iot.bzh/download/public/2020/CESDemo/Anbox/Android_images/android_arm64.img > /var/lib/anbox/android.img'

sudo systemctl enable anbox-container-manager.service
sudo systemctl start anbox-container-manager.service

sudo adb start-server

anbox wait-ready


# See also: https://github.com/anbox/anbox/issues/1214

# Running:
# ANBOX_LOG_LEVEL=debug anbox session-manager --gles-driver=translator --single-window --window-size=1024,768 &
# ANBOX_LOG_LEVEL=debug anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
