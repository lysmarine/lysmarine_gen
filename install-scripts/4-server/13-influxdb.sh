#!/bin/bash -e

apt-get clean

apt-get -y -q install influxdb chronograf # TODO: kapacitor

systemctl unmask influxdb
systemctl disable influxdb

systemctl disable chronograf
# TODO: systemctl disable kapacitor
