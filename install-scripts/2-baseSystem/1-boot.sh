#!/bin/bash -e
apt-get install -y -q plymouth  plymouth-label;

## This override the default tty1 behaviour to make it more discrete during the boot process
install -v -d "/etc/systemd/system/getty@tty1.service.d"
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

## Debian
if [ -f /etc/default/grub ] ; then
  install -m0644 -v $FILE_FOLDER/grub "/etc/default/grub"
  install -m0644 -v $FILE_FOLDER/background.png "/boot/grub/background.png"
  echo FRAMEBUFFER=y >> /etc/initramfs-tools/conf.d/splash
  update-initramfs -u
  update-grub
fi

## Theming of the boot process
install -v $FILE_FOLDER/ascii_logo.txt "/etc/motd"
cp -r $FILE_FOLDER/dreams "/usr/share/plymouth/themes/"
plymouth-set-default-theme dreams

# Armbian
if [ -f /etc/issue ] ;then
	rm /etc/issue /etc/issue.net
fi

# Raspbian enable this to intercept keystroke during the boot process, (for ondemand cup freq management.) Lysmarine don't want to set it that way.
if [[ $LMOS == 'Raspbian' ]]; then
	systemctl disable triggerhappy.service
fi
