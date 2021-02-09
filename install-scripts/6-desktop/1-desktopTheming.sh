#!/bin/bash -e

apt-get install -yq rofi fonts-roboto xclip qt5-style-plugins materia-gtk-theme xbacklight


## Install icon theme Griffin-Icons-Griffin-Ghost
wget https://github.com/LordShenron/Griffin-Icons/archive/Griffin-Ghost.zip -O /tmp/Griffin-Ghost.zip
unzip /tmp/Griffin-Ghost.zip -d /usr/local/share/icons/
rm /tmp/Griffin-Ghost.zip

cp -r $FILE_FOLDER/awesome /home/user/.config/awesome
chown -R 1000:1000 /home/user/.config/awesome

install -m 0644 $FILE_FOLDER/Trolltech.conf "/etc/xdg/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/"

install -d -m 755 "/etc/gtk-2.0/"
install -d -m 755 "/etc/gtk-3.0/"
install -o 1000 -g 1000  -v $FILE_FOLDER/gtkrc         "/etc/gtk-2.0/"
install -o 1000 -g 1000  -v $FILE_FOLDER/settings.ini  "/etc/gtk-3.0/"

install -d -o 1000 -g 1000 -m 755 "/home/user/.config/pcmanfm/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/pcmanfm/default/"
install -d -o 1000 -g 1000 -m 755 "/home/user/.config/libfm/"
install -o 1000 -g 1000  -v $FILE_FOLDER/pcmanfm.conf  "/home/user/.config/pcmanfm/default/"
install -o 1000 -g 1000  -v $FILE_FOLDER/libfm.conf    "/home/user/.config/libfm/"
