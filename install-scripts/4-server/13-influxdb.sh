#!/bin/bash -e

apt-get clean

apt-get -y -q install influxdb

systemctl unmask influxdb

#systemctl enable influxdb

