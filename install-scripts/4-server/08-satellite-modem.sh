#!/bin/bash -e

apt-get -y -q install wvdial ppp picocom slurm

if [ $LMARCH == 'armhf' ]; then
  apt-get -y -q install pppstatus
fi

# See: http://newt.phys.unsw.edu.au/~mcba/iridiumLinux.html
install -v -m 0644 $FILE_FOLDER/wvdial-iridium.conf "/etc/"

# See https://github.com/tdolby/python-iridium-modem/
pip3 install python-iridium-modem

