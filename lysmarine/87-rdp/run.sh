#!/bin/bash -e

apt-get install -y xrdp
cp $FILE_FOLDER/Xwrapper.config "/etc/X11/Xwrapper.config"

# systemctl disable xrdp.service
# systemctl disable xrdp-sesman.service
