##!/bin/sh

echo 0 > /DietPi/dietpi/.install_stage

ifup eth0

/DietPi/dietpi/func/dietpo-set-_dphys-swapfile

sudo su -c "/DietPi/dietpi/login"
