#!/bin/bash -e

apt-get -y -q install cups system-config-printer

usermod -a -G lpadmin user

