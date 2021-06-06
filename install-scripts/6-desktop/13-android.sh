#!/bin/bash -e

apt-get install -y ffmpeg libsdl2-2.0-0 adb wget \
  gcc git pkg-config meson ninja-build \
  libavcodec-dev libavformat-dev libavutil-dev libsdl2-dev

git clone https://github.com/Genymobile/scrcpy
cd scrcpy
chmod +x ./install_release.sh
./install_release.sh
cd ..
rm -rf scrcpy

git clone https://github.com/M0Rf30/android-udev-rules.git
cd android-udev-rules

# Copy rules file
cp -v 51-android.rules /etc/udev/rules.d/51-android.rules

# Change file permissions
chmod a+r /etc/udev/rules.d/51-android.rules

# Add the adbusers group if it's doesn't already exist
cp android-udev.conf /usr/lib/sysusers.d/
systemd-sysusers

# Add your user to the adbusers group
gpasswd -a user adbusers

cd ..
rm -rf android-udev-rules

install -v -m 0644 $FILE_FOLDER/scrcpy.desktop "/usr/local/share/applications/"

############################

apt-get install -y cargo

apt-get install -y autoadb

