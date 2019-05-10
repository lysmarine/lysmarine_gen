#!/bin/bash -e
apt-get install -y gsimplecal pavucontrol libgtk2.0-dev

install    -o 1000 -g 1000 $FILE_FOLDER/panelbg.png "/usr/share/panelbg.png"

install -d -o 1000 -g 1000 "/home/dietpi/.config/lxpanel/default/panels"
install    -o 1000 -g 1000 $FILE_FOLDER/panel "/home/dietpi/.config/lxpanel/default/panels/panel"

install -d -o 1000 -g 1000 "/home/dietpi/.config/fbpanel"
install    -o 1000 -g 1000 $FILE_FOLDER/default "/home/dietpi/.config/fbpanel/default"

install -d -o 1000 -g 1000 -m 755 "/home/dietpi/.config/tint2/"
install    -o 1000 -g 1000 -v $FILE_FOLDER/tint2rc "/home/dietpi/.config/tint2/"

install -d /home/dietpi/.config/openbox
echo 'fbpanel &' >> /home/dietpi/.config/openbox/autostart

git clone https://github.com/FredericGuilbault/fbpanel

cd fbpanel
git checkout develop

./configure --prefix=/usr/
make
make install

rm -rf fbpanel
