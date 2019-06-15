#!/bin/bash

# Lysmarine script to modify the default DietPi image prior to install lysmarine on it.
# Mainly fonfiguration and hacks to make it play nice with Lysmarine.

# Usage:
# - This script take no arguments
#-------------------------------------------------------

# the install process of lysmarine will make dietpi run his first boot process.
# We need to reset this

 systemctl enable dietpi-fs_partition_resize.service
 systemctl enable dietpi-ramlog.service
 systemctl enable dietpi-firstboot.service
 systemctl enable dietpi-ramdisk.service
 systemctl enable dietpi-preboot.service
 systemctl disable dietpi-boot.service
 systemctl disable dietpi-postboot.service
# systemctl disable dietpi-kill_ssh.service
# systemctl disable dietpi-wifi-monitor.service


systemctl unmask systemd-logind.service

cp ./dietpi.txt /boot/

cp ./firstBoot.sh /
chmod a+x /firstBoot.sh

sed -i 's/#ADD_POINT/\/lysmarineFirstBoot.sh/g' /home/dietpi/.profile
