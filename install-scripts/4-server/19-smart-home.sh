#!/bin/bash -e

apt-get install -y python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev libjpeg-dev \
   zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0 tzdata

useradd -rm homeassistant -G dialout,gpio,i2c

mkdir -p /srv/homeassistant
chown homeassistant:homeassistant /srv/homeassistant

{
cat << EOF
  cd /srv/homeassistant
  python3 -m venv .
  source bin/activate
  python3 -m pip install wheel
  pip3 install homeassistant
  mkdir -p /home/homeassistant/.homeassistant
  rm -rf /home/homeassistant/.cache
EOF
} | sudo -u homeassistant -H -s

bash -c 'cat << EOF > /etc/systemd/system/home-assistant@homeassistant.service
[Unit]
Description=Home Assistant
After=network-online.target
[Service]
Type=simple
User=%i
WorkingDirectory=/home/%i/.homeassistant
ExecStart=/srv/homeassistant/bin/hass -c "/home/%i/.homeassistant"

[Install]
WantedBy=multi-user.target
EOF'

systemctl disable home-assistant@homeassistant

######################## ESPHome

mkdir -p /home/homeassistant/.homeassistant/esphome
chown homeassistant:homeassistant /home/homeassistant/.homeassistant/esphome
cd /srv
mkdir esphome
chown homeassistant:homeassistant esphome

{
cat << EOF
  cd /srv/esphome
  python3 -m venv .
  source bin/activate
  python3 -m pip install wheel
  pip3 install esphome tornado esptool
  rm -rf /home/homeassistant/.cache
EOF
} | sudo -u homeassistant -H -s


bash -c 'cat << EOF > /etc/systemd/system/esphome@homeassistant.service
[Unit]
Description=ESPHome Dashboard
After=home-assistant@homeassistant.service
Requires=home-assistant@homeassistant.service

[Service]
Environment="PATH=/srv/esphome/bin:/home/homeassistant/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Type=simple
User=%i
WorkingDirectory=/home/%i/.homeassistant/esphome
ExecStart=/srv/esphome/bin/esphome dashboard /home/%i/.homeassistant/esphome/

[Install]
WantedBy=multi-user.target
EOF'

systemctl disable esphome@homeassistant

