#!/bin/bash -e
apt-get install -y gsimplecal pavucontrol libgtk2.0-dev

install    -o 1000 -g 1000 $FILE_FOLDER/panelbg.png "/usr/share/panelbg.png"


install -d -o 1000 -g 1000 "/home/pi/.config/fbpanel"
install    -o 1000 -g 1000 $FILE_FOLDER/default "/home/pi/.config/fbpanel/default"

install -d  -o 1000 -g 1000 /home/pi/.config/openbox
echo 'fbpanel &' >> /home/pi/.config/openbox/autostart

git clone https://github.com/FredericGuilbault/fbpanel
pushd ./fbpanel
git checkout lysmarine_flavour

./configure --prefix=/usr/
make
make install

popd
rm -rf fbpanel
