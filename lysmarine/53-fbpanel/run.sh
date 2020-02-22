#!/bin/bash -e
apt-get install -y gsimplecal pavucontrol libgtk2.0-dev



## Install fbpanel
git clone https://github.com/lysmarine/fbpanel
pushd ./fbpanel
git checkout lysmarine_flavour

./configure --prefix=/usr/
make
make install
popd
rm -rf fbpanel



## Install configuration files. 
install -d -o 1000 -g 1000 "/home/user/.config/fbpanel"
install    -o 1000 -g 1000 $FILE_FOLDER/default "/home/user/.config/fbpanel/default"

## Start fbpanel on openbox boot. 
install -d -o 1000 -g 1000 /home/user/.config/openbox
echo 'fbpanel -p default &' >> /home/user/.config/openbox/autostart



## Opencpn have a different location on arm64 arch du to the fact that it's complied by hand.
if [ $LMBUILD == armbian-pineA64 ] ;then
	sed -i 's/\/usr\/bin\/opencpn/\/usr\/local\/bin\/opencpn/' "/home/user/.config/fbpanel/default"
fi