#!/bin/bash -e
echo 'root:changeme' | chpasswd

oldUser=$(cat /etc/passwd | grep 1000:1000 | cut -f1 -d:) 

if [[ ! -z $oldUser ]]; then 
	userdel -r -f $oldUser
	rm /etc/sudoers.d/010_pi-nopasswd 
fi

adduser --uid 1000 --home /home/user --quiet --disabled-password -gecos "lysmarine" user
echo 'user:changeme' | chpasswd

echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers

install -v $FILE_FOLDER/all_all_users_to_shutdown_reboot.pkla "/etc/polkit-1/localauthority/50-local.d/"
install -v $FILE_FOLDER/org.freedesktop.NetworkManager.pkla  "/etc/polkit-1/localauthority/10-vendor.d/"
usermod -a -G netdev user

if [ $LMBUILD == armbian-pineA64 ] ;then
	usermod -a -G tty user
	usermod -a -G sudo user
	echo 'PATH="/sbin:/usr/sbin:$PATH"' > /home/user/.profile
	rm /root/.not_logged_in_yet
fi