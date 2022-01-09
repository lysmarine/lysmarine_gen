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


