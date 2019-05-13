#!/bin/bash
 systemctl enable dietpi-fs_partition_resize.service
 systemctl enable dietpi-ramlog.service
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

sed -i 's/#ADD_POINT/\/firstBoot.sh/g' /home/dietpi/.profile
