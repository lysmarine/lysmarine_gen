##!/bin/sh

#systemctl disable getty@tty1.service

ifup eth0
sudo su -c "/DietPi/dietpi/login"
sed -i 's/lysmarineFirstBoot.sh//g' /home/dietpi/.profile

systemctl disable dietpi-boot.service ## needed for the first boot as there some installation chunks hidden in here, But not needed after install.
