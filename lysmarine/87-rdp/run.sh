#!/bin/bash

apt-get install -y -q xrdp
install -v $FILE_FOLDER/Xwrapper.config "/etc/X11/Xwrapper.config"
