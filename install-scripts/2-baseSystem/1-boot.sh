#!/bin/bash -e
apt-get install -yq plymouth;

## RaspiOS boot config
if [ -f /boot/config.txt  ] ;then
	cat $FILE_FOLDER/appendToConfig.txt >> /boot/config.txt
fi

## RaspiOS boot config
if [ -f /boot/cmdline.txt ] ; then
  #console=serial0,115200 console=tty1 root=PARTUUID=b1214a26-02 rootfstype=ext4 fsck.repair=yes rootwait quiet init=/usr/lib/raspberrypi-sys-mods/firstboot
  sed -i '$s/$/\ loglevel=1\ splash\ quiet\ logo.nologo\ plymouth.ignore-serial-consoles\ console=tty3\ rd.systemd.show_status=false/' /boot/cmdline.txt
fi

## Armbian boot config
if [ -f /boot/armbianEnv.txt ] ; then
	echo "console=serial" >> /boot/armbianEnv.txt
fi

## Debian grub settings
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

## Armbian specific
rm /etc/issue || true
rm /etc/issue.net || true

## Raspios: disable on boot management options for ondemand cup freq management. Lysmarine don't want to set it that way.
systemctl disable triggerhappy.service || /bin/true
