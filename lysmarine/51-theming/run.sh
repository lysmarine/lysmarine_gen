#!/bin/bash -e
install  -d -o 1000 -g 1000 -m 755 -d "/home/pi/.themes"
install  -d -o 1000 -g 1000 -m 755 -d "/home/pi/.icons"


rm -rf openbox-theme-collections
rm -rf flat-remix
rm -rf gtk-theme-collections
rm -rf Ant-Dracula
git clone -q --depth=1 https://github.com/addy-dclxvi/openbox-theme-collections
git clone -q --depth=1 https://github.com/daniruiz/flat-remix

cp -rf ./openbox-theme-collections/Numix-Clone /home/pi/.themes/
chown -R pi:pi /home/pi/.themes/Numix-Clone
cp -rf flat-remix/Flat-Remix-Blue /home/pi/.icons/Flat-Remix-Dark
chown -R pi:pi /home/pi/.icons/Flat-Remix-Dark

rm -rf openbox-theme-collections
rm -rf flat-remix





install -d -o 1000 -g 1000 -m 755 "/home/pi/.config/"
install -d -o 1000 -g 1000 -m 755 "/home/pi/.config/feh/"
install -d -o 1000 -g 1000 -m 755 "/home/pi/.config/gtk-3.0/"
install -d -o 1000 -g 1000 -m 755 "/home/pi/.config/openbox/"
install -d -o 1000 -g 1000 -m 755 "/home/pi/.config/terminator/"
install -d -o 1000 -g 1000 -m 755 "/home/pi/.config/pcmanfm/default"
install -d -o 1000 -g 1000 -m 755 "/home/pi/.config/libfm/"
install -o 1000 -g 1000  -v $FILE_FOLDER/.gtkrc-2.0    "/home/pi/"
install -o 1000 -g 1000  -v $FILE_FOLDER/water.jpg     "/home/pi/.config/feh/"
install -o 1000 -g 1000  -v $FILE_FOLDER/settings.ini  "/home/pi/.config/gtk-3.0/"
install -o 1000 -g 1000  -v $FILE_FOLDER/autostart     "/home/pi/.config/openbox/"
install -o 1000 -g 1000  -v $FILE_FOLDER/rc.xml        "/home/pi/.config/openbox/"
install -o 1000 -g 1000  -v $FILE_FOLDER/config        "/home/pi/.config/terminator/"
install -o 1000 -g 1000  -v $FILE_FOLDER/pcmanfm.conf  "/home/pi/.config/pcmanfm/default/"
install -o 1000 -g 1000  -v $FILE_FOLDER/libfm.conf    "/home/pi/.config/libfm/"
install -o 1000 -g 1000  -v $FILE_FOLDER/.conkyrc      "/home/pi/.conkyrc"
