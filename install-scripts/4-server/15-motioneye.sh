#!/bin/bash -e

apt-get clean

# See https://github.com/ccrisan/motioneye/wiki/Install-On-Raspbian

apt-get -y -q install motion

python3 -m pip install --upgrade motioneye

apt-get clean
