#!/bin/bash -e
on_chroot << EOF
# https://github.com/chesty/overlayroot
  sudo mkinitramfs -o /boot/init.gz


  git clone https://github.com/chesty/overlayroot.git
  git clone --depth=1 https://github.com/chesty/overlayroot.git
  cd overlayroot

EOF
