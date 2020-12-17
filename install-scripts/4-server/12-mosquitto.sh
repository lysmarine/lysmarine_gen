#!/bin/bash -e

apt-get -y -q install mosquitto mosquitto-clients

install -o mosquitto -g mosquitto -d /var/log/mosquitto
