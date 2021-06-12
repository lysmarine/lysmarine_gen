#!/bin/bash -e

apt-get clean

apt-get -y -q install empathy


# FB messenger

if [ $LMARCH == 'armhf' ]; then
  arch=armv7l
elif [ $LMARCH == 'arm64' ]; then
  arch=arm64
elif [ $LMARCH == 'amd64' ]; then
  arch=x64
else
  arch=$LMARCH
fi

apt-get -y install libappindicator3-1 libindicator3-7

wget https://github.com/mquevill/caprine/releases/download/v2.53.0-ARM/caprine_2.53.0_${arch}.deb

dpkg -i caprine_2.53.0_${arch}.deb

rm caprine_2.53.0_${arch}.deb
