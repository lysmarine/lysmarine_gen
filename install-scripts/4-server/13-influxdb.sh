#!/bin/bash -e

apt-get clean

apt-get -y -q install influxdb chronograf kapacitor

systemctl unmask influxdb
systemctl disable influxdb

systemctl disable chronograf
systemctl disable kapacitor
