#!/bin/bash -e

on_chroot << EOF

rm -rf /home/border # ???

apt-get purge -y xterm
apt-get purge -y vim
apt-get purge -y plymouth

rm -f /usr/share/applications/vim.desktop
rm -f /usr/share/applications/PyCrust.desktop
rm -f /usr/share/applications/XRCed.desktop

rm -rf /home/pi/Public  /home/pi/Templates /home/pi/Videos /home/pi/Music /home/pi/Pictures /home/pi/Documents /home/pi/Desktop
EOF
