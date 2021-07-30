#!/bin/bash -e

echo "Not supported and highly experimental feature. Exiting..."
exit 1

sudo apt-get -q -y install android-tools-adb git curl unzip

sudo mkdir "/dev/binderfs"
sudo mount -t binder binder /dev/binderfs
sudo ln -s /dev/binderfs /dev/binder

sudo snap install --devmode --edge anbox

sudo bash -c 'wget -q -O - https://iot.bzh/download/public/2020/CESDemo/Anbox/Android_images/android_arm64.img > /var/lib/anbox/android.img'

anbox system-info

sudo systemctl enable anbox-container-manager.service
sudo systemctl start anbox-container-manager.service

sudo adb start-server

# See also: https://github.com/anbox/anbox/issues/

# Running:
# ANBOX_LOG_LEVEL=debug anbox session-manager --gles-driver=translator --single-window --window-size=1024,768 &
# ANBOX_LOG_LEVEL=debug anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
# anbox wait-ready