#!/bin/bash -e

myArch=$(dpkg --print-architecture)

if [ "armhf" != "$myArch" ] ; then
    echo "armhf version of the distribution is required. Exiting..."
    exit 1
fi

# See: https://flightaware.com/adsb/piaware/

sudo systemctl enable dump1090-fa
sudo systemctl enable lighttpd
sudo systemctl enable piaware

sudo systemctl start dump1090-fa
sudo systemctl start lighttpd
sudo systemctl start piaware

sudo bash -c 'cat << EOF > /usr/local/share/applications/adsb.desktop
[Desktop Entry]
Name=SDR ADS-B
Exec=gnome-www-browser http://localhost:8186/dump1090-fa
StartupNotify=true
Terminal=false
Type=Application
Icon=gnome-globe
Categories=HamRadio;SDR
Keywords=HamRadio;SDR
EOF'

# reboot
