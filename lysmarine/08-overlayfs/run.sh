#!/bin/bash -E
apt-get install -y -q busybox git

git clone https://github.com/chesty/overlayroot.git
cd ./overlayroot.git 
#./install.sh
cd ..



if [ $LMBUILD == raspbian ] ;then # WHY TWICE ???
	mkinitramfs -o /boot/init.gz
else


if ! grep -q "^initramfs " /boot/config.txt; then
    echo initramfs init.gz >> /boot/config.txt
fi

if ! grep -q "^overlay" /etc/initramfs-tools/modules; then
    echo overlay >> /etc/initramfs-tools/modules
fi


cp ./overlayroot/hooks-overlay /etc/initramfs-tools/hooks/
cp ./overlayroot/init-bottom-overlay /etc/initramfs-tools/scripts/init-bottom/



if [ $LMBUILD == raspbian ] ;then
	mkinitramfs -o /boot/init.gz

else
	update-initramfs -k $(uname -r) -u

fi

