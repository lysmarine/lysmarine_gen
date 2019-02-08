#!/bin/bash -e

on_chroot << EOF
pip install ujson

git clone https://github.com/seandepagnier/RTIMULib2
cd RTIMULib2/Linux/python
python setup.py build
python setup.py install
mkdir /home/pi/.pypilot
echo '{"host": "localhost"}' > /home/pi/.pypilot/signalk.conf
cd ../
EOF
