#!/bin/bash -e
apt-get install -y -q git
## this stage depend on stage 18-users for the pypilot user creation
## adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot

# Op way
apt-get install -y -q python3 python3-serial libpython3-dev python3-numpy python3-scipy swig python3-ujson \
python3-pyudev python3-pil python3-flask python3-opengl python3-pip python3-dev python3-setuptools  python3-wxgtk4.0 \
libffi-dev python3-gevent

pip3 install pywavefront pyglet gps gevent-websocket Flask-SocketIO python-socketio

## je pense que la meilleur approche est de favoriser PIP pcq dean deploi sur tiny core et n'est pas interesser par debian. aussi pcq y'a du code pour arduino et que ca pourrais etre supporter par les dependances d'installation python


#Lysmarine way
## Install apt deps
#apt-get install -y -q python3 python3-pip libpython3-dev   #python3-dev libpython3-dev python3-dev
#apt-get install -y -q swig #ask by the compiler
#apt-get install -y -q libatlas-base-dev #numpy won't work without this
#apt-get install -y -q freeglut3 libgl1 libglu1-mesa libgle3 #debian package says pyopengl depend on theses (pypilot_calibration need at least one of them)
#apt-get install -y -q python-wxgtk4.0 # wxpython is the pip package. I don't have the balls for this one, too much compiling depedencys.

#pip3 install numpy pillow serial gps pyudev pywavefront pyglet serial scipy \
#			 gevent-websocket python-socketio flask flask-socketio pyopengl

if [ $LMOS == 'Raspbian' ] ;then
	apt-get install -y -q wiringpi
fi



	## Install RTIMULib2 as it's a dependency of pypilot
	if [[ ! -d ./RTIMULib2 ]]; then
		git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
	fi
	echo "Build and install RTIMULib2"
	pushd ./RTIMULib2/Linux/python
		python3 setup.py install
	popd


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
install -d /usr/local/share/applications
#install    -v                 $FILE_FOLDER/pypilot_control.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/pypilot_calibration.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/pypilot_webapp.desktop "/usr/local/share/applications/" # Depend on stage 57-nativfier to build the app

## Give permission to sudo chrt without password for the user pypilot.
echo "" >> /etc/sudoers
echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/chrt' >> /etc/sudoers
