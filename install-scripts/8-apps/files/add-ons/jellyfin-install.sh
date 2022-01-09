#!/bin/bash -e

sudo bash -c 'cat << EOF > /usr/local/share/applications/jellyfin.desktop
[Desktop Entry]
Type=Application
Name=Jellyfin
GenericName=Jellyfin
Comment=Jellyfin
Exec=gnome-www-browser http://localhost:8096/
Terminal=false
Icon=video
Categories=WWW;Internet
EOF'

sudo systemctl enable jellyfin
sudo systemctl start jellyfin

echo "visit http://localhost:8096/ to continue set up"

