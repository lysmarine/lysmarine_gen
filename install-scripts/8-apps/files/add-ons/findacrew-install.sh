#!/bin/bash -e

sudo bash -c 'cat << EOF > /usr/local/share/applications/findacrew.desktop
[Desktop Entry]
Type=Application
Name=Find a Crew
GenericName=Find a Crew
Comment=Find a Crew
Exec=gnome-www-browser https://www.findacrew.net/
Terminal=false
Icon=gnome-globe
Categories=WWW;Internet
EOF'
