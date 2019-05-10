#!/bin/bash -e
install  -d -o 1000 -g 1000 -m 755 -d "/home/dietpi/.themes"
install  -d -o 1000 -g 1000 -m 755 -d "/home/dietpi/.icons"


rm -rf openbox-theme-collections
rm -rf flat-remix
rm -rf gtk-theme-collections
rm -rf Ant-Dracula
git clone -q --depth=1 https://github.com/addy-dclxvi/openbox-theme-collections
git clone -q --depth=1 https://github.com/daniruiz/flat-remix

cp -rf ./openbox-theme-collections/Numix-Clone /home/dietpi/.themes/
chown -R dietpi:dietpi /home/dietpi/.themes/Numix-Clone
cp -rf flat-remix/Flat-Remix-Blue /home/dietpi/.icons/Flat-Remix-Dark
chown -R dietpi:dietpi /home/dietpi/.icons/Flat-Remix-Dark

rm -rf openbox-theme-collections
rm -rf flat-remix





install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/"
install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/feh/"
install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/gtk-3.0/"
install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/openbox/"
install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/terminator/"
install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/pcmanfm/default"
install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/libfm/"
install -o 1000 -g 1000  -v $FILE_FOLDER/.gtkrc-2.0    "/home/dietpi/"
install -o 1000 -g 1000  -v $FILE_FOLDER/water.jpg     "/home/dietpi/.config/feh/"
install -o 1000 -g 1000  -v $FILE_FOLDER/settings.ini  "/home/dietpi/.config/gtk-3.0/"
install -o 1000 -g 1000  -v $FILE_FOLDER/autostart     "/home/dietpi/.config/openbox/"
install -o 1000 -g 1000  -v $FILE_FOLDER/rc.xml        "/home/dietpi/.config/openbox/"
install -o 1000 -g 1000  -v $FILE_FOLDER/config        "/home/dietpi/.config/terminator/"
install -o 1000 -g 1000  -v $FILE_FOLDER/pcmanfm.conf  "/home/dietpi/.config/pcmanfm/default/"
install -o 1000 -g 1000  -v $FILE_FOLDER/libfm.conf    "/home/dietpi/.config/libfm/"
install -o 1000 -g 1000  -v $FILE_FOLDER/.conkyrc      "/home/dietpi/.conkyrc"
