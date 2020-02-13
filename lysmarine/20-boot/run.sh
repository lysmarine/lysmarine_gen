#!/bin/bash -e
apt-get install -y -q plymouth;

install -v -m0644 $FILE_FOLDER/skip-prompt.conf "/etc/systemd/system/getty@tty1.service.d/"

if [ -f /boot/config.txt  ] ;then #raspbian
	cat $FILE_FOLDER/appendToConfig.txt >> /boot/config.txt
fi

if [ -f /boot/cmdline.txt ] ; then #raspbian
	sed -i '$s/$/\ loglevel=1\ splash\ quiet\ logo.nologo\ vt.global_cursor_default=0\ plymouth.ignore-serial-consoles/' /boot/cmdline.txt
fi

if [ -f /boot/armbianEnv.txt ] ; then #armbian
	echo "console=serial" >> /boot/armbianEnv.txt
fi

install -v $FILE_FOLDER/ascii_logo.txt "/etc/motd"
cp -r $FILE_FOLDER/dreams "/usr/share/plymouth/themes/"
plymouth-set-default-theme dreams

rm /etc/issue /etc/issue.net
