#!/bin/bash -e

## this stage depend on stage 18-users for the pypilot user creation 
## adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot

## Install apt depedencys
apt-get install -y -q python-setuptools python-gps python-serial libpython-dev \
python-numpy python-scipy swig python-pillow python-flask python-socketio \
python-pip python-pylirc  python-flask python-gevent-websocket \
python-wxgtk4.0 python-opengl python-wxtools

if [ $LMBUILD == raspbian ] ;then
	apt-get install -y -q wiringpi
fi

## Install python depedencys
pip install wheel
pip install pyglet ujson PyOpenGL PyWavefront pyudev flask_socketio

pushd /home/pypilot
	
	## Install RTIMULib2 as it's a dependency of pypilot 
	git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
	pushd ./RTIMULib2/Linux/python
		python setup.py install
	popd
	rm -rf ./RTIMULib2

	## Get pypilot
	git clone https://github.com/pypilot/pypilot.git

	pushd ./pypilot
		git checkout db173ae4409aba2900dfd58c50bf8a409cd954e7 # Temporary regression due to broken GUI 
	popd 

	## Get pypilot_data
	git clone --depth=1 https://github.com/pypilot/pypilot_data.git
	cp -rv ./pypilot_data/* ./pypilot
	rm -rf ./pypilot_data

	## Build and install pypilot
	pushd ./pypilot
		python setup.py build
		python setup.py install
	popd

	rm -rf pypilot
popd

## Install the service files
install -v -m 0644 $FILE_FOLDER/pypilot@.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_web.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_web.socket "/etc/systemd/system/"

systemctl enable pypilot@pypilot.service
systemctl enable pypilot_web.service

## Install the user config files
install -d -v -o pypilot -g pypilot -m 0755 /home/pypilot/.pypilot
install    -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/signalk.conf "/home/pypilot/.pypilot/"
install    -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/webapp.conf  "/home/pypilot/.pypilot/"

## Install The .desktop files
#install    -v                 $FILE_FOLDER/pypilot_control.desktop "/usr/share/applications/"
install -v $FILE_FOLDER/pypilot_calibration.desktop "/usr/share/applications/"
install -v $FILE_FOLDER/pypilot_webapp.desktop "/usr/share/applications/" # Depend on stage 57-nativfier to build the app

## Give permission to sudo chrt without password for the user pypilot. 
echo "" >> /etc/sudoers
echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/chrt' >> /etc/sudoers