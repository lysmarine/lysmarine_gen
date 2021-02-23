#!/bin/bash -e

apt-get clean

install -v $FILE_FOLDER/jtides.desktop /usr/local/share/applications/

install -d -m 755 "/usr/local/share/jtides"

wget -q -O - https://arachnoid.com/JTides/JTides.jar > /usr/local/share/jtides/JTides.jar
