#!/bin/bash -e

cat  $FILE_FOLDER/appendToConfig.txt >> /boot/config.txt

cp $FILE_FOLDER/splashScreen /bin/splashScreen
chmod 0775 /bin/splashScreen
cp $FILE_FOLDER/ascii_logo.txt /etc/motd
cp $FILE_FOLDER/splash.png /usr/share/splash.png

cp $FILE_FOLDER/splashscreen.service "/etc/systemd/system/splashscreen.service"
chmod 0644 "/etc/systemd/system/splashscreen.service"

apt-get install -y fbi ;
systemctl enable splashscreen.service
