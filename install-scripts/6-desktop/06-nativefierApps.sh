#!/bin/bash -e

apt-get clean

apt-get -y -q install nodejs libnss3 gnome-icon-theme unzip
npm install nativefier -g --unsafe-perm

install -d '/usr/local/share/bbn-checklist'
install -v -m 0644 $FILE_FOLDER/bbn-checklist/asciidoctor.css "/usr/local/share/bbn-checklist/"
install -v -m 0644 $FILE_FOLDER/bbn-checklist/bbn-checklist.html "/usr/local/share/bbn-checklist/"
install -v -m 0644 $FILE_FOLDER/bbn-checklist/bareboat-necessities-logo.svg "/usr/local/share/bbn-checklist/"

## Install icons and .desktop files
install -d -o 1000 -g 1000 /home/user/.local/share/icons
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/icons/freeboard-sk.png /home/user/.local/share/icons/
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/icons/signalk.png /home/user/.local/share/icons/
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/icons/dockwa.png /home/user/.local/share/icons/
install -d /usr/local/share/applications

## arch name translation
if [ $LMARCH == 'armhf' ]; then
  arch=armv7l
elif [ $LMARCH == 'arm64' ]; then
  arch=arm64
elif [ $LMARCH == 'amd64' ]; then
  arch=x64
else
  arch=$LMARCH
fi

USER_AGENT="Mozilla/5.0 (Linux; Android 10; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.86 Mobile Safari/537.36"

########################################################################################################################

echo "setTheme('dark')" >./pypilot_darktheme.js
nativefier -a $arch --inject ./pypilot_darktheme.js --disable-context-menu --disable-dev-tools --single-instance \
  --name "Pypilot_webapp" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png \
  "http://localhost:8080" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "AvNav" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png \
  "http://localhost:8099/viewer/avnav_viewer.html?noCloseDialog=true" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "bbn-launcher" --icon /usr/share/icons/gnome/256x256/apps/utilities-system-monitor.png \
  "http://localhost:4997" /opt/

install -v -m 0644 $FILE_FOLDER/pypilot_webapp.desktop "/usr/local/share/applications/"
install -v -m 0644 $FILE_FOLDER/avnav.desktop "/usr/local/share/applications/"

## Make folder name arch independent.
mv /opt/Pypilot_webapp-linux-$arch /opt/Pypilot_webapp
mv /opt/AvNav-linux-$arch /opt/AvNav
mv /opt/bbn-launcher-linux-$arch /opt/bbn-launcher

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/Pypilot_webapp/chrome-sandbox
  chmod 4755 /opt/AvNav/chrome-sandbox
  chmod 4755 /opt/bbn-launcher/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/*
npm cache clean --force

########################################################################################################################

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "SignalK" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/admin/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "Freeboard-sk" --icon /home/user/.local/share/icons/freeboard-sk.png \
  "http://localhost:80/@signalk/freeboard-sk/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "kip-dash" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/@mxtommy/kip/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "instrumentpanel" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/@signalk/instrumentpanel/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "sailgauge" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/@signalk/sailgauge/" /opt/

install -v $FILE_FOLDER/signalk.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/Freeboard-sk.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/kip-dash.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/instrumentpanel.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/sailgauge.desktop /usr/local/share/applications/

## Make folder name arch independent.
mv /opt/SignalK-linux-$arch /opt/SignalK
mv /opt/Freeboard-sk-linux-$arch /opt/Freeboard-sk
mv /opt/kip-dash-linux-$arch /opt/kip-dash
mv /opt/instrumentpanel-linux-$arch /opt/instrumentpanel
mv /opt/sailgauge-linux-$arch /opt/sailgauge

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/SignalK/chrome-sandbox
  chmod 4755 /opt/Freeboard-sk/chrome-sandbox
  chmod 4755 /opt/kip-dash/chrome-sandbox
  chmod 4755 /opt/instrumentpanel/chrome-sandbox
  chmod 4755 /opt/sailgauge/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/*
npm cache clean --force

########################################################################################################################

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "MusicBox" --icon /usr/share/icons/gnome/48x48/apps/multimedia-volume-control.png \
  "http://localhost:6680/musicbox_webclient" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "Dockwa" --icon /home/user/.local/share/icons/dockwa.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=dockwa" -u "$USER_AGENT" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "Nauticed" --icon /usr/share/icons/gnome/256x256/actions/go-jump.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=nauticed" -u "$USER_AGENT" /opt/

mv /opt/MusicBox-linux-$arch /opt/MusicBox
mv /opt/Dockwa-linux-$arch /opt/Dockwa
mv /opt/Nauticed-linux-$arch /opt/Nauticed

install -m 644 $FILE_FOLDER/musicbox.desktop "/usr/local/share/applications/"
install -m 644 $FILE_FOLDER/dockwa.desktop "/usr/local/share/applications/"
install -m 644 $FILE_FOLDER/nauticed.desktop "/usr/local/share/applications/"

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/MusicBox/chrome-sandbox
  chmod 4755 /opt/Dockwa/chrome-sandbox
  chmod 4755 /opt/Nauticed/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/*
npm cache clean --force

########################################################################################################################

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "youtube" --icon /usr/share/icons/gnome/48x48/apps/multimedia-volume-control.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=youtube" -u "$USER_AGENT" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "facebook" --icon /usr/share/icons/Adwaita/256x256/emotes/face-cool.png \
  --internal-urls ".*" \
  "http://localhost:4997/www?name=facebook" -u "$USER_AGENT" /opt/

mv /opt/youtube-linux-$arch /opt/youtube
mv /opt/facebook-linux-$arch /opt/facebook

install -v $FILE_FOLDER/youtube.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/facebook.desktop /usr/local/share/applications/

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/youtube/chrome-sandbox
  chmod 4755 /opt/facebook/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/*
npm cache clean --force

########################################################################################################################

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "skwiz" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/skwiz/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "motioneye" --icon /usr/share/icons/gnome/32x32/devices/camera-web.png \
  "http://localhost:8765/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "tuktuk" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/tuktuk-chart-plotter/" /opt/

nativefier -a $arch --disable-context-menu --disable-dev-tools --single-instance \
  --name "sk-autopilot" --icon /home/user/.local/share/icons/signalk.png \
  "http://localhost:80/@signalk/signalk-autopilot/" /opt/

install -v -m 0644 $FILE_FOLDER/skwiz.desktop "/usr/local/share/applications/"
install -v -m 0644 $FILE_FOLDER/motioneye.desktop "/usr/local/share/applications/"
install -v -m 0644 $FILE_FOLDER/tuktuk.desktop "/usr/local/share/applications/"
install -v -m 0644 $FILE_FOLDER/signalk-autopilot.desktop "/usr/local/share/applications/"

mv /opt/skwiz-linux-$arch /opt/skwiz
mv /opt/motioneye-linux-$arch /opt/motioneye
mv /opt/tuktuk-linux-$arch /opt/tuktuk
mv /opt/sk-autopilot-linux-$arch /opt/sk-autopilot

## On debian, the sandbox environment fail without GUID/SUID
if [ $LMOS == Debian ]; then
  chmod 4755 /opt/skwiz/chrome-sandbox
  chmod 4755 /opt/motioneye/chrome-sandbox
  chmod 4755 /opt/tuktuk/chrome-sandbox
  chmod 4755 /opt/sk-autopilot/chrome-sandbox
fi

# Minimize space by linking identical files
hardlink -v -t /opt/*
npm cache clean --force

apt-get clean
