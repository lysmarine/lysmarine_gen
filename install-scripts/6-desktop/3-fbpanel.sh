#!/bin/bash -e
apt-get install -y gsimplecal pavucontrol libgtk2.0-dev fbpanel libatk-adaptor

## Install configuration files.
install -o 1000 -g 1000 -d "/home/user/.config/fbpanel"
install -o 1000 -g 1000 $FILE_FOLDER/default "/home/user/.config/fbpanel/default"

## Start fbpanel on openbox boot.
install -o 1000 -g 1000 -d /home/user/.config/openbox
echo 'fbpanel -p default &' >>/home/user/.config/openbox/autostart
echo 'chromium --headless &' >>/home/user/.config/openbox/autostart
