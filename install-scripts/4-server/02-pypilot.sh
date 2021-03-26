#!/bin/bash -e
apt-get install -y -q git
## this stage depends on stage 18-users for the pypilot user creation
## adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot

# Op way
apt-get install -y -q --no-install-recommends python3 python3-serial libpython3-dev python3-numpy python3-scipy swig python3-ujson \
  python3-pyudev python3-pil python3-flask python3-opengl python3-pip python3-dev python3-setuptools python3-wxgtk4.0 \
  libffi-dev python3-gevent python3-zeroconf

apt-get install -y -q watchdog
systemctl enable watchdog

pip3 install pywavefront pyglet gps gevent-websocket Flask-SocketIO python-socketio

#if [ $LMOS == 'Raspbian' ]; then
#  apt-get install -y -q wiringpi
#fi

pushd ./stageCache
  # Install RTIMULib2 as it's a dependency of pypilot
  if [[ ! -d ./RTIMULib2 ]]; then
    git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
  fi
  echo "Build and install RTIMULib2"

  pushd ./RTIMULib2/Linux/python
    python3 setup.py install
    python3 setup.py clean --all
  popd

#  apt-get install -yq python3-rtimulib2-pypilot

  echo "Get pypilot"
  if [[ ! -d ./pypilot ]]; then
    git clone https://github.com/pypilot/pypilot.git
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
    python3 setup.py clean --all
  popd
popd

## Install the service files
install -v -m 0644 $FILE_FOLDER/pypilot@.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_web.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_web.socket "/etc/systemd/system/"

systemctl disable pypilot@pypilot.service
systemctl enable pypilot_web.service

## Install the user config files
install -v -o pypilot -g pypilot -m 0755 -d /home/pypilot/.pypilot
install -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/signalk.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/webapp.conf "/home/pypilot/.pypilot/"

## Install The .desktop files
install -d /usr/local/share/applications
install -v $FILE_FOLDER/pypilot_calibration.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/pypilot_control.desktop "/usr/local/share/applications/"

## Give permission to sudo chrt without a password for the user pypilot.
echo "" >>/etc/sudoers
echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/chrt' >>/etc/sudoers

## Reduce excessive logging
sed '1 i :msg, contains, "autopilot failed to read imu at time" ~' -i /etc/rsyslog.conf

