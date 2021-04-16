#!/bin/bash -e

sudo bash -c 'cat << EOF > /usr/local/share/applications/marinetraffic.desktop
[Desktop Entry]
Type=Application
Name=Marine Traffic
GenericName=Marine Traffic
Comment=Marine Traffic
Exec=gnome-www-browser https://www.marinetraffic.com/
Terminal=false
Icon=gnome-globe
Categories=WWW;Internet
EOF'
