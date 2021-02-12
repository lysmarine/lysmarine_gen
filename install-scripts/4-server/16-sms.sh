#!/bin/bash -e

apt-get -y -q install ppp usb-modeswitch usb-modeswitch-data
apt-get -y -q install gammu

apt-get clean
