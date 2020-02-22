#!/bin/bash -e
apt-get install -y -q plymouth;

## This override the default tty1 behaviour to make it more discrete during the boot process
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