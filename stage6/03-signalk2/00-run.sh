#!/bin/bash -e

on_chroot << EOF

cd /home/pi/.config/
git clone https://github.com/SignalK/signalk-server-node.git
cd signalk-server-node
npm install

EOF
