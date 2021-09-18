#!/bin/bash -e

# See: https://github.com/CarpeNoctem/pat-on-a-pi

cd /home/user

mkdir winlink-pat && cd winlink-pat

curl https://raw.githubusercontent.com/bareboat-necessities/pat-on-a-pi/main/setup_pat.sh > setup_pat.sh; bash setup_pat.sh

cd ..

