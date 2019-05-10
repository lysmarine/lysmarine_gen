#!/bin/bash -e

apt-get install -y python-pip sudo whois x11vnc python-wxtools hostapd dnsmasq python-smbus  python-can python-dev


install -d  "/opt/openplotter/"
install -d -o 1000 -g 1000 "/home/dietpi/.local/share/applications/"
install -o 1000 -g 1000 $FILE_FOLDER/openplotter.desktop "/home/dietpi/.local/share/applications/"

pip install setuptools  --no-cache-dir
pip install requests ujson websocket websocket-client paho-mqtt geomag     pyudev serial smbus      websocket websocket-client python-can    pynmea2  --no-cache-dir

cd /opt/
git clone https://gitlab.com/FredericGuilbault/openplotter.git
cd openplotter
git checkout  lysmarine_flavor

wget http://www.fars-robotics.net/install-wifi -O /usr/bin/install-wifi
chmod +x /usr/bin/install-wifi
find /opt/openplotter/Network/ -type f -name *.sh -exec chmod +x \{\} \; # make .sh file executable
