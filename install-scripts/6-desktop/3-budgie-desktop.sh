#!/bin/bash -e

apt-get install -y libatk-adaptor
apt-get install -y budgie-desktop

## Start budgie-desktop on openbox boot.
install -o 1000 -g 1000 -d /home/user/.config/openbox
echo 'chromium --headless &' >>/home/user/.config/openbox/autostart
echo 'budgie-desktop &' >>/home/user/.config/openbox/autostart
