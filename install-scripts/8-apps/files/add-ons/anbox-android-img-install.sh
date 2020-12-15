#!/bin/bash -e

sudo bash -c 'curl https://iot.bzh/download/public/2020/CESDemo/Anbox/Android_images/android_arm64.img > /var/lib/anbox/android.img'

sudo systemctl enable anbox-container-manager.service
sudo systemctl start anbox-container-manager.service

# Running:
# ANBOX_LOG_LEVEL=debug anbox session-manager --gles-driver=translator --single-window --window-size=1024,768 &
# ANBOX_LOG_LEVEL=debug anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
