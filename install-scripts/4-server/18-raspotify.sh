#!/bin/bash -e

if [ $LMARCH == 'armhf' ]; then
  apt-get -y -q install raspotify
  usermod -a -G raspotify user
  systemctl disable raspotify
  install -d -m 755 -o 1000 -g 1000 "/home/user/.config/systemd/"
  install -d -m 755 -o 1000 -g 1000 "/home/user/.config/systemd/user/"
  install -v -m 644 -o 1000 -g 1000 $FILE_FOLDER/raspotify.service "/home/user/.config/systemd/user/raspotify.service"
fi

apt-get clean
