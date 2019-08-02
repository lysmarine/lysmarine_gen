#!/bin/bash -e
apt-get install -y onboard dconf-editor dbus-x11

install -d "/usr/share/onboard/"
install -v $FILE_FOLDER/onboard.dconf "/usr/share/onboard/"
install -v $FILE_FOLDER/a11y.dconf "/usr/share/onboard/"

install -d  -o dietpi /home/dietpi/.config/openbox/
echo "sleep 1 ; dconf load /org/onboard/ < /usr/share/onboard/onboard.dconf &" >> /home/dietpi/.config/openbox/autostart
echo "sleep 1 ; dconf load / < /usr/share/onboard/a11y.dconf &" >> /home/dietpi/.config/openbox/autostart
