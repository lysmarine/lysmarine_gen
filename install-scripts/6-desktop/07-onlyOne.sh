#!/bin/bash -e

apt-get install -y -q wmctrl

install -v -m 0755 $FILE_FOLDER/onlyone "/usr/local/bin/"
