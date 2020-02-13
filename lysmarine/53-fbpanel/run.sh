#!/bin/bash -e
apt-get install -y gsimplecal pavucontrol libgtk2.0-dev

git clone https://github.com/FredericGuilbault/fbpanel
pushd ./fbpanel
git checkout lysmarine_flavour

./configure --prefix=/usr/
make
make install
popd
rm -rf fbpanel

install -d -o 1000 -g 1000 "/home/user/.config/fbpanel"
install    -o 1000 -g 1000 $FILE_FOLDER/default "/home/user/.config/fbpanel/default"

install -d -o 1000 -g 1000 /home/user/.config/openbox
echo 'fbpanel -p default &' >> /home/user/.config/openbox/autostart

install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/freeboard-sk.png "/home/user/.local/share/icons/freeboard-sk.png"

if [ $LMBUILD == armbian-pineA64 ] ;then
	sed -i 's/\/usr\/bin\/opencpn/\/usr\/local\/bin\/opencpn/' "/home/user/.config/fbpanel/default"
fi