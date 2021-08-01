#!/bin/bash -e

apt-get -y -q install cups

usermod -a -G lpadmin user

