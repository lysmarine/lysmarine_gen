#!/bin/bash -e

#Arm systems can use u-boot x86 must use grub 
if [[ $LMOS == 'Raspbian' ]]; then # Rapsberrys 1,2&3 does not boot normaly due to the proprietary blob 
	apt-get install -y -q libraspberrypi-bin raspberrypi-kernel raspberrypi-sys-mods raspberrypi-archive-keyring dialog

 cat > /etc/fstab <<EOF
proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
EOF
	echo 'console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait' > /boot/cmdline.txt
	wget https://raw.githubusercontent.com/RPi-Distro/pi-gen/master/stage1/00-boot-files/files/config.txt -o /boot/config.txt

fi

if [[ $LMOS == 'Debian' ]]; then # Debian specifics
	apt-get install -y -q #extlinux syslinux-common bash-completion
	pushd /dev
	#apt-get install -y -q makedev 
	# MAKEDEV generic
	apt-get install -y -q  grub # linux-image-amd64
	popd
fi


apt-get install -y -q plymouth;

## This override the default tty1 behaviour to make it more discrete during the boot process
install -d        /etc/systemd/system/getty@tty1.service.d
install -v -m0644 $FILE_FOLDER/skip-prompt.conf "/etc/systemd/system/getty@tty1.service.d/"

## Raspbian
if [ -f /boot/config.txt  ] ;then 
	cat $FILE_FOLDER/appendToConfig.txt >> /boot/config.txt
fi

## Raspbian
if [ -f /boot/cmdline.txt ] ; then 
	sed -i '$s/$/\ loglevel=1\ splash\ quiet\ logo.nologo\ vt.global_cursor_default=0\ plymouth.ignore-serial-consoles/' /boot/cmdline.txt
fi

 ## Armbian
if [ -f /boot/armbianEnv.txt ] ; then
	echo "console=serial" >> /boot/armbianEnv.txt
fi

## Theming of the boot prcess
install -v $FILE_FOLDER/ascii_logo.txt "/etc/motd"
cp -r $FILE_FOLDER/dreams "/usr/share/plymouth/themes/"
plymouth-set-default-theme dreams

# Armbian
rm /etc/issue /etc/issue.net

# Raspbian neable it in intercept keystroke during the boot process for ondemand cup freq management. 
systemctl disable triggerhappy.services




