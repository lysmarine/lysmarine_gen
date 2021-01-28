#!/bin/bash -e

apt-get install -y onboard dconf-cli dbus-x11 at-spi2-core acpid

install -d "/usr/share/onboard/"
install -v $FILE_FOLDER/onboard.dconf "/usr/share/onboard/"
install -v $FILE_FOLDER/a11y.dconf "/usr/share/onboard/"
install -d "/usr/share/onboard/themes"
install -v -m0644 $FILE_FOLDER/Lysmarine.theme "/usr/share/onboard/themes"

## Dconf injection on the first boot + self commenting sed replace.
install -d -o 1000 -g 1000 /home/user/.config/openbox/
echo "dconf load /org/onboard/ < /usr/share/onboard/onboard.dconf &" >> /home/user/.config/openbox/autostart
echo "dconf load / < /usr/share/onboard/a11y.dconf &" >> /home/user/.config/openbox/autostart

echo "sed -i 's/^dconf\ /#&/' /home/user/.config/openbox/autostart; " >> /home/user/.config/openbox/autostart
echo "sed -i 's/^sed\ /#&/'   /home/user/.config/openbox/autostart; " >> /home/user/.config/openbox/autostart
