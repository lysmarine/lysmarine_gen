#!/bin/bash -e
echo 'root:changeme' | chpasswd

if [ $LMBUILD == raspbian ] ;then
	userdel -r -f pi
	rm /etc/sudoers.d/010_pi-nopasswd
fi

if [ ! -d /home/user ] ; then
	adduser --home /home/user --quiet --disabled-password -gecos "lysmarine" user
fi
echo 'user:changeme' | chpasswd

echo -n 'lysmarine' > /etc/hostname
echo '127.0.1.1	lysmarine' >> /etc/hosts

echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers
