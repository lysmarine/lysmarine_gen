#!/bin/bash -e

apt-get clean

apt-get -y -q install motion

python3 -m pip install --upgrade motioneye

apt-get clean
