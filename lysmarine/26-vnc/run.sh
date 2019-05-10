#!/bin/bash -e

apt-get install -y tightvncserver
cp $FILE_FOLDER/vnc.service "/etc/systemd/system/vnc.service"
