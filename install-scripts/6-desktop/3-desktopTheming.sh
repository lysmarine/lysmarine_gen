#!/bin/bash -e

## Activate maliit virtual keyboard.
install -o 1000 -g 1000 -d -m 755 /home/user/.config
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/kwinrc "/home/user/.config/"

## Disable the screen locker, screen saver and others power management configurations.
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/kscreenlockerrc "/home/user/.config/"
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/ksmserverrc "/home/user/.config/"
install -v -o 1000 -g 1000 -m 600 $FILE_FOLDER/powermanagementprofilesrc "/home/user/.config/"

### chromium config. change landings page.
#sed -i 's/"first_run_tabs":["*"]/"first_run_tabs":["https://lysmarine.org"]/' /etc/chromium/master_preferences
# "first_run_tabs":["https://welcome.raspberrypi.org/raspberry-pi-os?id=UNIDENTIFIED"]
# rm /etc/chromium/master_preferences
