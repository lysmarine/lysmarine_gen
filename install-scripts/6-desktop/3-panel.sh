#!/bin/bash -e
apt-get install -y lxpanel gsimplecal menu

## Install configuration files.
install -d -o 1000 -g 1000 "/home/user/.config/lxpanel/lysmarine/panels/"
install    -o 1000 -g 1000 -m 0644 $FILE_FOLDER/panel "/home/user/.config/lxpanel/lysmarine/panels/"

## Start fbpanel on openbox boot.
install -d -o 1000 -g 1000 /home/user/.config/openbox
echo 'lxpanel -p lysmarine &' >> /home/user/.config/openbox/autostart
