#!/bin/bash -e

sudo apt-get -q -y install avnav xterm mpg123

install -o 1000 -g 1000 -d /home/user/AvNavCharts
install -o 1000 -g 1000 -d /home/user/AvNavCharts/out

adduser avnav audio

systemctl enable avnav
