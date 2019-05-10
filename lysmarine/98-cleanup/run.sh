#!/bin/bash -e

rm -f /usr/share/applications/vim.desktop
rm -f /usr/share/applications/PyCrust.desktop
rm -f /usr/share/applications/XRCed.desktop

rm -rf /home/dietpi/Public  /home/dietpi/Templates /home/dietpi/Videos /home/dietpi/Music /home/dietpi/Pictures /home/dietpi/Documents /home/dietpi/Desktop
apt -y autoremove
