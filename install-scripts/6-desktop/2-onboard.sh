#!/bin/bash -e

apt-get install -y onboard dconf-cli dbus-x11 at-spi2-core acpid

install -d "/usr/share/onboard/"
install -v $FILE_FOLDER/onboard.dconf "/usr/share/onboard/"
install -v $FILE_FOLDER/a11y.dconf "/usr/share/onboard/"
install -d "/usr/share/onboard/themes"
install -v -m0644 $FILE_FOLDER/Lysmarine.theme "/usr/share/onboard/themes"

## Dconf injection on the first boot + self commenting sed replace.
install -d -o 1000 -g 1000 /home/user/.config
echo "dconf load /org/onboard/ < /usr/share/onboard/onboard.dconf &" >> /home/user/.config/autostart
echo "dconf load / < /usr/share/onboard/a11y.dconf &" >> /home/user/.config/autostart
echo "sed -i 's/^dconf\ /#&/' /home/user/.config/openbox/autostart; " >> /home/user/.config/autostart
echo "sed -i 's/^sed\ /#&/'   /home/user/.config/openbox/autostart; " >> /home/user/.config/autostart

# Hack the theme to change onboard icon in the sysbar so we can have an icon that is meaningful
ln -fs /usr/local/share/icons/Griffin-Icons-Griffin-Ghost/scalable/apps/preferences-desktop-keyboard.svg /usr/local/share/icons/Griffin-Icons-Griffin-Ghost/scalable/apps/onboard-settings.svg
ln -fs /usr/local/share/icons/Griffin-Icons-Griffin-Ghost/scalable/apps/preferences-desktop-keyboard.svg /usr/local/share/icons/Griffin-Icons-Griffin-Ghost/scalable/apps/onboard-mono.svg
ln -fs /usr/local/share/icons/Griffin-Icons-Griffin-Ghost/scalable/apps/preferences-desktop-keyboard.svg /usr/local/share/icons/Griffin-Icons-Griffin-Ghost/scalable/apps/onboard.svg
