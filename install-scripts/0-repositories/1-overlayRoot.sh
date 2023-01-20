#!/bin/bash -e
apt-get install -yq initramfs-tools

if [[ $LMOS = Raspbian ]]; then
  apt-get install -yq busybox
  install -m0755 -v $FILE_FOLDER/rootfs-overlay "/etc/initramfs-tools/scripts/init-bottom/"

  echo "overlay" >> /etc/initramfs-tools/modules

  echo "ramfsfile=initrd" >> /boot/config.txt
  echo "initramfs init.gz " >> /boot/config.txt

  echo "INITRD=Yes" >> /etc/default/raspberrypi-kernel
  echo "RPI_INITRD=Yes" >> /etc/default/raspberrypi-kernel

  sed -i 's/\/usr\/lib\/raspberrypi-sys-mods\/firstboot/\/init.gz/' /boot/cmdline.txt

	 # Build one initramfs for each arm architecture supported by raspbian
	 for kernelLocation in /lib/modules/*v7+/ ; do
   		kernelName=$(basename $kernelLocation)
   		mkinitramfs -k -o /boot/initramfs-$kernelName $kernelName
   done

	 # Instruct the kernel to load initramfs
   cp $(ls /boot/initramfs*v7+) /boot/init.gz
	 cp $(ls /boot/initramfs*v7+) /host-rootfs/lysmarine_gen/

   rm /etc/init.d/resize2fs_once
fi