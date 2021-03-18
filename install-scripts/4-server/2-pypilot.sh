#!/bin/bash -e
apt-get install -y -q git
## this stage depend on stage 18-users for the pypilot user creation
## adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot

# Op way
apt-get install -y -q python3 python3-serial libpython3-dev python3-numpy python3-scipy swig python3-ujson \
python3-pyudev python3-pil python3-flask python3-opengl python3-pip python3-dev python3-setuptools  python3-wxgtk4.0 \
libffi-dev python3-gevent

pip3 install pywavefront pyglet gps gevent-websocket Flask-SocketIO python-socketio

apt-get install -y -q wiringpi || /bin/true

	## Install RTIMULib2 as it's a dependency of pypilot
	apt-get install -yq python3-rtimulib2-pypilot

	echo "Get pypilot";
	if [[ ! -d ./pypilot ]]; then
		git clone https://github.com/pypilot/pypilot.git
		# pushd ./pypilot
		# 	git checkout db173ae4409aba2900dfd58c50bf8a409cd954e7 # Temporary regression due to broken GUI
		# popd
		git clone --depth=1 https://github.com/pypilot/pypilot_data.git
		cp -rv ./pypilot_data/* ./pypilot
		rm -rf ./pypilot_data
		pushd ./pypilot
			python3 setup.py build
		popd
	fi
	## Build and install pypilot
	pushd ./pypilot
		python3 setup.py install
	popd


## Install the user config files
install -d -v -o pypilot -g pypilot -m 0755 /home/pypilot/.pypilot
install    -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/signalk.conf "/home/pypilot/.pypilot/"
install    -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/webapp.conf  "/home/pypilot/.pypilot/"

## Install The .desktop files
install -d /usr/local/share/applications

install -v $FILE_FOLDER/pypilot_calibration.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/pypilot_webapp.desktop "/usr/local/share/applications/" # Depend on stage 57-nativfier to build the app

## Give permission to sudo chrt without password for the user pypilot.
echo "" >> /etc/sudoers
echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/chrt' >> /etc/sudoers

## Set default state
systemctl disable pypilot_web
systemctl mask pypilot_web
systemctl disable pypilot@pypilot.service