#!/bin/bash -e

# dirty fix to mitigate the dependency problem between rpi and debian repo.
apt-get -q -y install libbluetooth-dev=5.55-3.1+rpt2

apt-get -q -y --no-install-recommends install avnav # mpg123
apt-get -q -y install avnav-history-plugin || true  # avnav-ocharts-plugin
apt-get -q -y -o Dpkg::Options::="--force-overwrite" install avnav-oesenc || true
apt-get -q -y install avnav-mapproxy-plugin || true

install -o 0 -g 0 -d /usr/lib/systemd/system/avnav.service.d
install -o 0 -g 0 -m 0644 $FILE_FOLDER/lys-avnav.conf /usr/lib/systemd/system/avnav.service.d/
install -o 0 -g 0 -d /usr/lib/avnav/lysmarine
install -o 0 -g 0 -m 0644 $FILE_FOLDER/avnav_server_lysmarine.xml "/usr/lib/avnav/lysmarine/"

systemctl enable avnav

