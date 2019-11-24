#!/bin/bash -e

cp $FILE_FOLDER/.kplex.conf "/home/pi/"
chmod 0755 /home/pi/.kplex.conf
chown 1000:1000 /home/pi/.kplex.conf
echo $ARCH

if [ "$ARCH" == "NativePC-BIOS-x86_64" ] ; then
        wget http://www.stripydog.com/download/kplex_1.4-1_amd64.deb
        dpkg -i kplex_1.4-1_amd64.deb
        rm kplex_1.4-1_amd64.deb
else
        wget http://www.stripydog.com/download/kplex_1.4-1_armhf.deb
        dpkg -i kplex_1.4-1_armhf.deb
        rm kplex_1.4-1_armhf.deb
fi
systemctl enable kplex
