#!/bin/bash -e


on_chroot << EOF
apt remove -y xterm

rm -rf /home/pi/Public  /home/pi/Templates /home/pi/Videos /home/pi/Music /home/pi/Pictures /home/pi/Documents /home/pi/Desktop
EOF
