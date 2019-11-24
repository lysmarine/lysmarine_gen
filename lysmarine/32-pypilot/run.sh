#!/bin/bash -e
apt-get install -y python-setuptools python-gps python-serial libpython-dev \
python-numpy python-scipy swig python-pillow python-flask python-socketio \
python-pip python-pylirc wiringpi python-flask python-gevent-websocket \
python-wxgtk3.0 python-opengl


mkdir -p "/home/pi/.pypilot"
cp $FILE_FOLDER/signalk.conf "/home/pi/.pypilot/"
chown 1000:1000 /home/pi/.pypilot/signalk.conf


cp $FILE_FOLDER/pypilot.desktop "/usr/share/applications/"
cp $FILE_FOLDER/pypilot_webapp.desktop "/usr/share/applications/"


pip install wheel
pip install pyglet ujson PyOpenGL PyWavefront flask_socketio




echo " RTIMULib2 : "
git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
cd RTIMULib2/Linux/python
python setup.py install

cd ../../
rm -rf /RTIMULib2

echo " Pypilot : "
cd /
git clone --depth=1 https://github.com/pypilot/pypilot.git
git clone --depth=1 https://github.com/pypilot/pypilot_data.git
cp -rv pypilot_data/* pypilot
rm -rf pypilot_data

cd pypilot
python setup.py build
python setup.py install
cd scripts/debian/
cp -r etc/systemd/system/* /etc/systemd/system/
cd /
rm -rf pypilot
