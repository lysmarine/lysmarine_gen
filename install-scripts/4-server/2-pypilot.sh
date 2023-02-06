#!/bin/bash -e
## NOTE this stage depend on stage 18-users for the pypilot user creation.

apt-get install -yq git python3 python3-pip python3-dev python3-setuptools libpython3-dev

apt-get install -yq \
    python3-serial \
	python3-numpy \
	python3-scipy \
	swig \
	python3-ujson \
    python3-pyudev \
    python3-pil \
    python3-flask \
    python3-engineio \
    python3-opengl  \
    python3-wxgtk4.0 \
    libffi-dev \
    python3-gevent \
    python3-ifaddr \
    python3-zeroconf \
    python3-certifi \
    python3-chardet \
    python3-idna \
    python3-requests \
    python3-urllib3

pip3 install \
    pywavefront \
    pyglet \
    gps \
    gevent-websocket \
    Flask-SocketIO \
    python-socketio

apt-get install -y -q wiringpi || /bin/true

## Install RTIMULib2 as it's a dependency of pypilot.
apt-get install -yq python3-rtimulib2-pypilot

## Download and build pypilot.
if [[ ! -d ./pypilot ]]; then
	git clone --depth=1 https://github.com/pypilot/pypilot.git
	git clone --depth=1 https://github.com/pypilot/pypilot_data.git
	cp -rv ./pypilot_data/* ./pypilot
	rm -rf ./pypilot_data
	pushd ./pypilot
		python3 setup.py build
	popd
fi

## Install pypilot.
pushd ./pypilot
	python3 setup.py install
	python3 setup.py clean --all
popd

## Install the user config files.
install -d -v -o pypilot -g pypilot -m 0755 /home/pypilot/.pypilot
install    -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/signalk.conf "/home/pypilot/.pypilot/"
install    -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/webapp.conf  "/home/pypilot/.pypilot/"

## Give permission to sudo chrt without password for the user pypilot.
echo "" >> /etc/sudoers
echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/chrt' >> /etc/sudoers

## Set default state.
#systemctl disable pypilot_web
#systemctl mask pypilot_web
systemctl disable pypilot@pypilot.service

## Reduce excessive logging.
sed '1 i :msg, contains, "autopilot failed to read imu at time" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "No IMU detected" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "No IMU Detected" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "Failed to open I2C bus" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "Using fusion algorithm Kalman" ~' -i /etc/rsyslog.conf
