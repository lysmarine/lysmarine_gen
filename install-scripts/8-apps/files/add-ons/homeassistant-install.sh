#!/bin/bash -e

sudo bash -c 'cat << EOF > /usr/local/share/applications/homeassistant.desktop
[Desktop Entry]
Type=Application
Name=HomeAssistant
GenericName=HomeAssistant
Comment=HomeAssistant
Exec=gnome-www-browser http://localhost:8123/
Terminal=false
Icon=user-home
Categories=WWW;Internet
EOF'

sudo systemctl --system daemon-reload
sudo systemctl enable home-assistant@homeassistant
sudo systemctl start home-assistant@homeassistant

echo "Wait for 15-20 min if starting for the first time."
echo "Visit http://localhost:8123/ to continue set up."
