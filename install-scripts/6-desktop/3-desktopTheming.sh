#!/bin/bash -e

## Activate maliit virtual keyboard.
install -o 1000 -g 1000 -d -m 755 /home/user/.config
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/kwinrc "/home/user/.config/"

## Disable the screen locker, screen saver and others power management configurations.
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/kscreenlockerrc "/home/user/.config/"
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/ksmserverrc "/home/user/.config/"
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/powermanagementprofilesrc "/home/user/.config/"

## As this file is not populated yet in build time, we hold an original copy of it. Then we remove krunner
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/plasma-org.kde.plasma.phone-appletsrc "/home/user/.config/"
sed  -i -e  's/plugin=org.kde.phone.krunner//' /home/user/.config/plasma-org.kde.plasma.phone-appletsrc

## Inject our own set of Favorites Application.
cat <<EOT >> /usr/share/plasma/look-and-feel/org.kde.plasma.phone/contents/plasmoidsetupscripts/org.kde.phone.homescreen.js
applet.writeConfig("Favorites", ["opencpn.desktop", "signalk.desktop", "xygrib.desktop"])
applet.reloadConfig()
EOT
