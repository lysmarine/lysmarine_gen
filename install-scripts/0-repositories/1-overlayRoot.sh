#!/bin/bash -e
apt-get install -yq initramfs-tools

if [[ $LMOS = Raspbian ]]; then

  apt-get install -yq busybox

# adding stuff to initramfs source
  install -m0755 -v $FILE_FOLDER/rootfs-overlay "/etc/initramfs-tools/scripts/init-bottom/"

  mkdir -p /etc/initramfs-tools/hooks
  install -m0755 -v $FILE_FOLDER/parted.sh "/etc/initramfs-tools/hooks/parted.sh"
  chmod a+x /etc/initramfs-tools/hooks/parted.sh

  install -m0755 -v $FILE_FOLDER/fdisk.sh "/etc/initramfs-tools/hooks/fdisk.sh"
  chmod a+x /etc/initramfs-tools/hooks/fdisk.sh

  install -m0755 -v $FILE_FOLDER/resize2fs.sh "/etc/initramfs-tools/hooks/resize2fs.sh"
  chmod a+x /etc/initramfs-tools/hooks/resize2fs.sh

  echo "overlay" >> /etc/initramfs-tools/modules

# tell RPI to rebuild custom initramfs uppon each kernel update.
  echo "SKIP_INITRAMFS_GEN=no" >>/etc/default/raspberrypi-kernel
  echo "RPI_INITRD=Yes" >> /etc/default/raspberrypi-kernel

# prevent default behaviour
  sed -i 's/init=\/usr\/lib\/raspberrypi-sys-mods\/firstboot//' /boot/firmware/cmdline.txt

  echo " debug " >> /boot/firmware/cmdline.txt
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

 # tell RPI to user our custom initramfs

cat >> /boot/firmware/config.txt << EOL

[pi2]
initramfs $(basename -a /boot/firmware/initramfs*v8 | tail -n1 ) followkernel

[pi3]
initramfs $(basename -a /boot/firmware/initramfs*v8 | tail -n1 ) followkernel

[pi4]
initramfs $(basename -a /boot/firmware/initramfs*v8 | tail -n1 ) followkernel

[pi5]
initramfs $(basename -a /boot/firmware/initramfs*2712 | tail -n1 ) followkernel

EOL
 
  # Instruct the kernel to load initramfs
  cp $(ls /boot/initramfs*7l+) /boot/init.gz
  cp $(ls /boot/initramfs*) /host-rootfs/lysmarine_gen/
  rm /etc/init.d/resize2fs_once
  systemctl disable dphys-swapfile
fi
