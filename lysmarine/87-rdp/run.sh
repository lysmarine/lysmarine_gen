#!/bin/bash

install -d /etc/systemd/system/xrdp.d
install -v -m 0644 $FILE_FOLDER/startLater.config "/etc/systemd/system/xrdp.d/"

apt-get install -y -q xrdp
install -v $FILE_FOLDER/Xwrapper.config "/etc/X11/Xwrapper.config"
