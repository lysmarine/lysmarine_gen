#!/bin/bash

## Install dependencies
apt-get -yq install gir1.2-webkit2-4.0
pip3 install pywebview
pip3 install PyQtWebEngine
pip3 install qtpy

## Copy files
# install -v -m 0755 $FILE_FOLDER/Freeboard-sk.py "/usr/local/bin/Freeboard-sk"
install -v -m 0755 $FILE_FOLDER/Pypilot_webapp.py "/usr/local/bin/Pypilot_webapp"
install -v -m 0755 $FILE_FOLDER/signalk_webapp.py "/usr/local/bin/signalk_webapp"
install -v -m 0755 $FILE_FOLDER/avnav_webapp.py "/usr/local/bin/avnav_webapp"
install -v -m 0755 $FILE_FOLDER/wdash.py "/usr/local/bin/wdash"

## todo for icon support
#python -m pyinstaller --icon    myscript.spec
#https://github.com/r0x0r/pywebview/issues/91

## Install icons and .desktop files for each service
install -d -o 1000 -g 1000 "/home/user/.local/share/icons"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/freeboard-sk.png "/home/user/.local/share/icons/freeboard-sk.png"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/signalk.png "/home/user/.local/share/icons/"
install -d /usr/local/share/applications
install -v $FILE_FOLDER/signalk.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/avnav_webapp.desktop "/usr/local/share/applications/"