#!/bin/bash -e

apt-get install -y git arc-theme

git clone -q --depth=1 --single-branch --branch Abyss-Desktop-Theme-Icons-and-Folders https://github.com/rtlewis88/rtl88-Themes.git
cp -rf rtl88-Themes/Abyss-DEEP-Suru-GLOW /usr/share/icons/Abyss-DEEP-Suru-GLOW
rm -rf rtl88-Themes

install -m 0644 $FILE_FOLDER/Trolltech.conf "/etc/xdg/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/"
install -d -m 755 "/etc/gtk-2.0/"
install -d -m 755 "/etc/gtk-3.0/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/openbox/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/pcmanfm/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/pcmanfm/default/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/libfm/"

install -o 1000 -g 1000  -v $FILE_FOLDER/gtkrc         "/etc/gtk-2.0/"
install -o 1000 -g 1000  -v $FILE_FOLDER/settings.ini  "/etc/gtk-3.0/"
install -o 1000 -g 1000  -v $FILE_FOLDER/rc.xml        "/home/user/.config/openbox/"
install -o 1000 -g 1000  -v $FILE_FOLDER/pcmanfm.conf  "/home/user/.config/pcmanfm/default/"
install -o 1000 -g 1000  -v $FILE_FOLDER/libfm.conf    "/home/user/.config/libfm/"
