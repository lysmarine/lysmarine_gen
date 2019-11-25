#!/bin/bash -e
apt-get install -y -q fbi ;

install -m0775  -v $FILE_FOLDER/splashScreen         "/bin/splashScreen"
install         -v $FILE_FOLDER/ascii_logo.txt       "/etc/motd"
install         -v $FILE_FOLDER/splash.png           "/usr/share/splash.png"
install -m0644  -v $FILE_FOLDER/splashscreen.service "/etc/systemd/system/splashscreen.service"

cat $FILE_FOLDER/appendToConfig.txt >> /boot/config.txt
echo -n " loglevel=1 splash quiet logo.nologo" >> /boot/cmdline.txt

systemctl enable splashscreen.service
