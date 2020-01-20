#!/bin/bash -e
apt-get install -y -q plymouth;


install -v $FILE_FOLDER/ascii_logo.txt       "/etc/motd"
cp -r $FILE_FOLDER/dreams "/usr/share/plymouth/themes/"

if [ $LMBUILD != debian-amd64 ] ;then
	install -v -m0644 $FILE_FOLDER/skip-prompt.conf "/etc/systemd/system/getty@tty1.service.d/"
fi



cat $FILE_FOLDER/appendToConfig.txt >> /boot/config.txt

if [ -f /boot/cmdline.txt ] ; then
	sed -i '$s/$/\ loglevel=1\ splash\ quiet\ logo.nologo\ vt.global_cursor_default=0/' /boot/cmdline.txt
fi


if [ -f /boot/armbianEnv.txt ] ; then
echo "console=serial" >> /boot/armbianEnv.txt

fi



plymouth-set-default-theme dreams

rm /etc/issue /etc/issue.net
