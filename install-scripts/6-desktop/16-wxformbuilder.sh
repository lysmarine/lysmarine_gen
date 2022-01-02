#!/bin/bash -e

apt-get -y install libwxgtk3.0-gtk3-dev libwxgtk-media3.0-gtk3-dev libboost-dev meson cmake make git

git clone --recursive https://github.com/wxFormBuilder/wxFormBuilder
cd wxFormBuilder
git checkout 2d20e717ac918a5f8f4728146c29a3d83a6a3afd  # Nov 1, 2021

meson _build --prefix $PWD/_install --buildtype=release
ninja -C _build install

cd _install

cp -r bin/* /usr/local/bin/
cp -r share/* /usr/local/share/
cp -r lib/arm*-linux-*/* /usr/local/lib/

cd ..

cd ..
rm -rf wxFormBuilder
