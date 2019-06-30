#!/bin/bash
# Lysmarine script to modify the default DietPi image prior to install lysmarine on it.
# Mainly fonfiguration and hacks to make it play nice with Lysmarine.



# force services states.
systemctl enable dietpi-fs_partition_resize.service
systemctl enable dietpi-firstboot.service

systemctl enable dietpi-preboot.service  # atm preboot is for led and cpu management
systemctl enable dietpi-boot.service # there is part of the install process in this
systemctl enable dietpi-postboot.service

systemctl enable dietpi-ramdisk.service
systemctl enable dietpi-ramlog.service

systemctl disable dietpi-kill_ssh.service
systemctl disable dietpi-wifi-monitor.service

# Apply our dietpi config file
cp -v $FILE_FOLDER/dietpi.txt /boot/

# Unfortunately lysmarine require a first boot install process.
cp  -v $FILE_FOLDER/lysmarineFirstBoot.sh /
chmod a+x /lysmarineFirstBoot.sh



# Remove the first boot script.
sed -i 's/#ADD_POINT/\/lysmarineFirstBoot.sh/g' /home/dietpi/.profile
