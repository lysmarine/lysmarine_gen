#!/bin/bash -e

apt-get clean

x11vnc=0
if [ $x11vnc == 1 ]; then
  apt-get install -y -q x11vnc

  install -v -m 644 $FILE_FOLDER/vnc.service "/etc/systemd/system/vnc.service"
  install -v -d -o 1000 -g 1000 "/home/user/.vnc"
  install -v -o 1000 -g 1000 $FILE_FOLDER/passwd "/home/user/.vnc/passwd"

  ## NOTE: The password file have been generated with the command
  ## x11vnc -storepasswd SECRETPASSWORD /home/user/.vnc/passwd
else
  apt-get -y install realvnc-vnc-server
fi

install -d /etc/systemd/system/xrdp.d

apt-get install -y -q xrdp
install -v $FILE_FOLDER/Xwrapper.config "/etc/X11/Xwrapper.config"

adduser xrdp ssl-cert
touch /var/log/xrdp.log
chown xrdp:adm /var/log/xrdp.log

systemctl disable xrdp
systemctl disable xrdp-sesman

if [ $x11vnc == 1 ]; then
  systemctl enable vnc
else
  systemctl enable vncserver-x11-serviced.service
fi
