#!/bin/bash -e
apt-get install -yq initramfs-tools

if [[ $LMOS = Raspbian ]]; then

  apt-get install -yq busybox

  install -m0755 -v $FILE_FOLDER/rootfs-overlay "/etc/initramfs-tools/scripts/init-bottom/"

  mkdir -p /etc/initramfs-tools/hooks
  echo "cp $(which parted) /usr/sbin/" >/etc/initramfs-tools/hooks/parted.sh
  install -m0755 -v $FILE_FOLDER/parted.sh "/etc/initramfs-tools/hooks/parted.sh"
  chmod a+x /etc/initramfs-tools/hooks/parted.sh

  echo "cp $(which fdisk) /usr/sbin/" >/etc/initramfs-tools/hooks/fdisk.sh
  install -m0755 -v $FILE_FOLDER/fdisk.sh "/etc/initramfs-tools/hooks/fdisk.sh"
  chmod a+x /etc/initramfs-tools/hooks/fdisk.sh

  echo "cp $(which resize2fs) /usr/sbin/" >/etc/initramfs-tools/hooks/resize2fs.sh
  install -m0755 -v $FILE_FOLDER/resize2fs.sh "/etc/initramfs-tools/hooks/resize2fs.sh"
  chmod a+x /etc/initramfs-tools/hooks/resize2fs.sh


  echo "overlay" >>/etc/initramfs-tools/modules


  echo "INITRD=Yes" >>/etc/default/raspberrypi-kernel
  echo "RPI_INITRD=Yes" >>/etc/default/raspberrypi-kernel

  sed -i 's/init=\/usr\/lib\/raspberrypi-sys-mods\/firstboot//' /boot/cmdline.txt


  # Build one initramfs for each arm architecture supported by raspbian
  for kernelLocation in /lib/modules/*/; do
    kernelName=$(basename $kernelLocation)
    kernelVersionNumber=$(echo $kernelName | cut -d"-" -f1 )
    mkinitramfs -k -o /boot/initramfs-$kernelName $kernelName
  done
 
  echo "include lysmarine_config.txt" >> /boot/config.txt
  touch lysmarine_config.txt
  echo "ramfsfile=initrd" >> /boot/lysmarine_config.txt


  cat >> /boot/lysmarine_config.txt <<EOL
[pi1]
initramfs initramfs-${kernelVersionNumber}+

[pi2]
initramfs initramfs-${kernelVersionNumber}-v7l+

[pi3]
initramfs initramfs-${kernelVersionNumber}-v7+

[pi4]
initramfs initramfs-${kernelVersionNumber}-v8+
EOL
 
  # Instruct the kernel to load initramfs
  cp $(ls /boot/initramfs*7l+) /boot/init.gz
  cp $(ls /boot/initramfs*) /host-rootfs/lysmarine_gen/
  rm /etc/init.d/resize2fs_once
fi
