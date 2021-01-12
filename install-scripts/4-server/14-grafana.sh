#!/bin/bash -e

apt-get clean

apt-get -y -q install grafana

systemctl disable grafana-server

apt-get clean

