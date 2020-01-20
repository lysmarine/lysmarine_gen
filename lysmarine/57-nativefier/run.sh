#!/bin/bash

apt-get -y -q install nodejs libnss3 gnome-icon-theme
npm install nativefier -g --unsafe-perm

install -d -o 1000 -g 1000 "/home/user/.local/share/icons"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/freeboard-sk.png "/home/user/.local/share/icons/freeboard-sk.png"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/signalk.png "/home/user/.local/share/icons/"

if [ $LMBUILD == raspbian ] ;then
	arch=armv7l
fi

if [ $LMBUILD == armbian-pineA64 ] ;then
	arch=arm64
fi



nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
--name "SignalK"   --icon /home/user/.local/share/icons/signalk.png \
"http://localhost:80" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
 --name "Freeboard-sk" --icon /home/user/.local/share/icons/freeboard-sk.png \
 "http://localhost/@signalk/freeboard-sk/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
 --name "SpeedSample" --icon /usr/share/icons/gnome/256x256/apps/utilities-system-monitor.png \
 "http://localhost:4998" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
	--name "Pypilot_webapp" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png  \
	"http://localhost:8080" /opt/
