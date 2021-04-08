#!/bin/bash

apt-get install -y -q xygrib

## Provide an alternative more meaningful icon for xygrib
install -o 1000 -g 1000 $FILE_FOLDER/logo_grib.png "/usr/share/icons/"

## This fix: https://github.com/opengribs/XyGrib/issues/271
sed -i "s/xygrib.png/xygrib/g" /usr/share/applications/xygrib.desktop
