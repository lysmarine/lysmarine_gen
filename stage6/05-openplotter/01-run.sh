#!/bin/bash -e

on_chroot << EOF

git clone https://github.com/sailoog/openplotter.git ;

cd openplotter ;
mkdir -p /home/pi/.config/openplotter ;
cp -r ./*  /home/pi/.config/openplotter/ ;
cd /home/pi/.config/openplotter/ ;

EOF
