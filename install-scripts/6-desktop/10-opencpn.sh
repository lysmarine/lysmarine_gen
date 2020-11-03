#!/bin/bash -e

apt-get install -y -q libportaudio2 libgtk-3-0 wx-common wx3.1-i18n libwxbase3.1-5v5 libwxgtk3.1-gtk3-5v5 libwxgtk-media3.1-5v5 libwxgtk-webview3.1-5v5 libwxsvg3

apt-get install -y -q opencpn

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"
