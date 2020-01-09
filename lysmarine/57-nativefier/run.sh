#!/bin/bash

apt-get -y -q install nodejs libnss3

npm install nativefier -g --unsafe-perm

install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/freeboard-sk.png "/home/pi/.local/share/icons/freeboard-sk.png"

nativefier -a armv7l --disable-context-menu --disable-dev-tools --single-instance \
--name "SignalK"   --icon /home/pi/.local/share/icons/signalk.png \
"http://localhost:80" /opt/

nativefier -a armv7l --disable-context-menu --disable-dev-tools --single-instance \
 --name "Freeboard-sk" --icon /home/pi/.local/share/icons/freeboard-sk.png \
 "http://localhost/@signalk/freeboard-sk/" /opt/

nativefier -a armv7l --disable-context-menu --disable-dev-tools --single-instance \
 --name "SpeedSample" --icon /usr/share/icons/gnome/256x256/apps/utilities-system-monitor.png \
 "http://localhost:4998" /opt/

 nativefier -a armv7l --disable-context-menu --disable-dev-tools --single-instance \
  --name "Tuktuk" --icon /home/pi/.icons/Flat-Remix-Dark/apps/scalable/android-studio.svg \
  "http://localhost:4999" /opt/

nativefier -a armv7l --disable-context-menu --disable-dev-tools --single-instance \
	--name "Pypilot_webapp" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png  \
	"http://localhost:8080" /opt/
