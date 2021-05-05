#!/bin/bash -e

sudo apt-get -y install tvheadend

sudo systemctl enable tvheadend
sudo systemctl start tvheadend

sudo bash -c 'cat << EOF > /usr/local/share/applications/tvheadend.desktop
[Desktop Entry]
Name=tvheadend
Exec=gnome-www-browser http://localhost:9981/
StartupNotify=true
Terminal=false
Type=Application
Icon=tv-symbolic
Categories=HamRadio;SDR
Keywords=HamRadio;SDR
EOF'
