#!/bin/bash

apt-get install -y -q xygrib

#install                 $FILE_FOLDER/XyGrib.desktop "/usr/local/share/applications"
install -o 1000 -g 1000 $FILE_FOLDER/logo_grib.png "/usr/share/icons/"
