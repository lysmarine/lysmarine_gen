#!/bin/bash

# pip install pywebview
# apt install -y -q python-gi python-gi-cairo python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.0

# echo "#!/usr/bin/env python" > /usr/local/bin/webdesktop
# echo "import webview" >> /usr/local/bin/webdesktop
# echo "webview.create_window('webdesktop', 'http://localhost:80')" >> /usr/local/bin/webdesktop
# echo "webview.start()" >> /usr/local/bin/webdesktop

# chmod 0755 /usr/local/bin/webdesktop

# npm install electron-packager -g --unsafe-perm
# electron-packager <sourcedir> <appname> --platform=<platform> --arch=<arch> [optional flags...]


apt-get -y -q install nodejs libnss3 gnome-icon-theme
npm install nativefier -g --unsafe-perm



## Install icons and .desktop files 
install -d -o 1000 -g 1000 "/home/user/.local/share/icons"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/freeboard-sk.png "/home/user/.local/share/icons/freeboard-sk.png"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/signalk.png "/home/user/.local/share/icons/"
install -d /usr/local/share/applications
install -v $FILE_FOLDER/signalk.desktop "/usr/local/share/applications/"



## arch name translation 
if [ $LMARCH == armhf ] ;then
 	arch=armv7l
fi

if [ $LMARCH == arm64 ] ;then #FIXME
	arch=arm64
fi

if [ $LMARCH == debian-vbox ] ;then #FIXME
	arch=x64
fi

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
--name "webdesktop"   --icon /usr/share/icons/gnome/256x256/actions/reload.png \
"http://localhost:80" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
--name "SignalK"   --icon /home/user/.local/share/icons/signalk.png \
"http://localhost:81" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
--name "Freeboard-sk" --icon /home/user/.local/share/icons/freeboard-sk.png \
"http://localhost/@signalk/freeboard-sk/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
--name "SpeedSample" --icon /usr/share/icons/gnome/256x256/apps/utilities-system-monitor.png \
"http://localhost:4998" /opt/

echo "setTheme('dark')" > ./pypilot_darktheme.js
nativefier -a $arch --inject ./pypilot_darktheme.js --disable-context-menu --disable-dev-tools --single-instance \
--name "Pypilot_webapp" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png  \
"http://localhost:8080" /opt/



## Make folder name arch independant. 
cp -r /opt/Freeboard-sk-linux-$arch /opt/Freeboard-sk
cp -r /opt/Pypilot_webapp-linux-$arch /opt/Pypilot_webapp
cp -r /opt/SignalK-linux-$arch /opt/SignalK
cp -r /opt/SpeedSample-linux-$arch /opt/SpeedSample
cp -r /opt/webdesktop-linux-$arch /opt/webdesktop

rm -r /opt/Freeboard-sk-linux-$arch
rm -r /opt/Pypilot_webapp-linux-$arch
rm -r /opt/SignalK-linux-$arch
rm -r /opt/SpeedSample-linux-$arch
rm -r /opt/webdesktop-linux-$arch


## On debian, the sandbox environement fail without GUID/SUID 
if [ $LMOS == Debian ] ;then
	chmod 4755 /opt/Freeboard-sk/chrome-sandbox
	chmod 4755 /opt/Pypilot_webapp/chrome-sandbox
	chmod 4755 /opt/SignalK/chrome-sandbox
	chmod 4755 /opt/SpeedSample/chrome-sandbox
fi

