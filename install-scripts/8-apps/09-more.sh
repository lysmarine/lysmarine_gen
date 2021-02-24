#!/bin/bash -e

apt-get clean
npm cache clean --force

apt-get -q -y install i2c-tools python3-smbus dos2unix traceroute telnet socat gdal-bin openvpn seahorse
systemctl disable openvpn

apt-get -q -y install dconf-editor gedit gnome-calculator gnome-weather gnome-chess openpref

apt-get clean

apt-get -q -y install sysstat jq xmlstarlet uhubctl iotop rsync timeshift at unrar snapd
systemctl disable snapd snapd.socket

#apt-get install software-properties-common

# rpi-clone
git clone https://github.com/billw2/rpi-clone.git
cd rpi-clone
cp rpi-clone rpi-clone-setup /usr/local/sbin
cd ..
rm -rf rpi-clone

apt-get -q -y install rpi-imager

apt-get clean
npm cache clean --force

apt-get -q -y install arduino

install -v -m 0755 $FILE_FOLDER/bbn-change-password.sh "/usr/local/bin/bbn-change-password"

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/add-ons/readme.txt "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/deskpi-pro-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-sample.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/wxtoimg-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/sdrglut-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/pactor-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/nmea-sleuth-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/tuktuk-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/qtvlm-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/predict-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/nodered-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/timezone-setup.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/calibrate-touchscreen.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/os-settings.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/change-password.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/scytalec-inmarsat-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/sailmail-pat-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/openplotter-install.sh "/home/user/add-ons/"

install -v $FILE_FOLDER/bbn-checklist.desktop "/usr/local/share/applications/"

install -d -m 0755 "/usr/local/share/colreg"
curl 'https://en.wikisource.org/api/rest_v1/page/pdf/International_Regulations_for_Preventing_Collisions_at_Sea' \
 -H 'Accept: */*;q=0.8' \
 -H 'Accept-Language: en-US,en;q=0.5' --compressed \
 -H 'DNT: 1' -H 'Connection: keep-alive' \
 -H 'Upgrade-Insecure-Requests: 1' -H 'TE: Trailers' \
 --output "/usr/local/share/colreg/colreg.pdf"
install -v $FILE_FOLDER/colreg.desktop "/usr/local/share/applications/"

install -d -m 0755 "/usr/local/share/knots"
install -v -m 0644 $FILE_FOLDER/knots/knots.html "/usr/local/share/knots/"
install -v -m 0644 $FILE_FOLDER/knots/knots.svg "/usr/local/share/knots/"
install -v -m 0644 $FILE_FOLDER/knots/License_free.txt "/usr/local/share/knots/"
install -v $FILE_FOLDER/knots.desktop "/usr/local/share/applications/"

install -d -o 1000 -g 1000 -m 0755 "/home/user/FloatPlans"

install -d '/usr/local/share/marine-life'
install -v -m 0644 $FILE_FOLDER/marine-life-id.html "/usr/local/share/marine-life/"
install -v $FILE_FOLDER/marine-life.desktop "/usr/local/share/applications/"

install -d -o 1000 -g 1000 -m 0755 "/home/user/.vessel"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/vessel.data "/home/user/.vessel/"
install -v -m 0755 $FILE_FOLDER/vessel-data.sh "/usr/local/bin/vessel-data"
install -v $FILE_FOLDER/vessel-data.desktop "/usr/local/share/applications/"
