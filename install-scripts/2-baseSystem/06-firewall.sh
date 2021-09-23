#!/bin/bash -e

apt-get -y -q install ufw

ufw default deny
ufw allow from 192.168.0.0/24
ufw allow from 10.10.0.0/24
ufw enable
