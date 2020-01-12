#!/bin/bash -e
if [ $LMBUILD == raspbian ] ;then
	userdel -r -f pi
	rm /etc/sudoers.d/010_pi-nopasswd
fi

if [ ! -d /home/user ] ; then
	adduser --home /home/user --quiet --disabled-password -gecos "lysmarine" user
fi
echo 'user:changeme' | chpasswd
echo 'root:changeme' | chpasswd

echo -n 'lysmarine' > /etc/hostname

echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers
