##!/bin/sh

#systemctl disable getty@tty1.service

ifup eth0
sudo su -c "/DietPi/dietpi/login"
sed -i 's/lysmarineFirstBoot.sh//g' /home/dietpi/.profile
