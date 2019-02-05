#!/bin/bash -e
install -d "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d"

on_chroot << EOF
systemctl enable getty@tty1.service &
echo 'if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then' >> /home/pi/.profile ;
echo '. startx' >> /home/pi/.profile ;
echo 'logout' >> /home/pi/.profile ;
echo 'fi' >> /home/pi/.profile ;
EOF
