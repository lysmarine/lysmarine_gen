#!/bin/bash -e

pushd /opt
  ARD_URL=https://downloads.arduino.cc
  ARD_FILE=arduino-1.8.16-linuxarm.tar.xz
  if [ $LMARCH == 'arm64' ]; then
    ARD_FILE=arduino-1.8.16-linuxaarch64.tar.xz
  fi
  wget $ARD_URL/$ARD_FILE
  xzcat $ARD_FILE | tar xvf -
  rm $ARD_FILE
  pushd arduino-1.8.16
    install -d /root/.config
    ./install.sh
    ./arduino-linux-setup.sh user
  popd
popd
