#!/bin/bash -e

# See: https://wxtoimgrestored.xyz

myArch=$(dpkg --print-architecture)

if [ "armhf" != "$myArch" ] ; then
    echo "armhf version of the distribution is required. Exiting..."
    exit 1
fi

cd ~
wget -q -O - https://wxtoimgrestored.xyz/beta/wxtoimg-armhf-2.11.2-beta.deb > wxtoimg-armhf-2.11.2-beta.deb

sudo apt-get install -y libxft2:armhf libasound2:armhf

sudo dpkg -i wxtoimg-armhf-2.11.2-beta.deb

sudo bash -c 'cat << EOF > /usr/local/share/applications/xwxtoimg.desktop
[Desktop Entry]
Type=Application
Name=WxToImg
GenericName=WxToImg
Comment=Weather Fax Image Processor
Exec=xwxtoimg
Terminal=false
Icon=gnome-globe
Categories=HamRadio;Weather
Keywords=HamRadio;Weather
EOF'
