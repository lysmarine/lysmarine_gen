#!/bin/bash -e

apt-get -y -q install ufw

ufw default deny
ufw allow from 192.0.0.0/8
ufw allow from 10.0.0.0/8
ufw enable
