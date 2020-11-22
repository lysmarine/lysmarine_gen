#!/bin/bash

apt-get install -y -q wmctrl

install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/onlyone "/usr/local/bin/"
