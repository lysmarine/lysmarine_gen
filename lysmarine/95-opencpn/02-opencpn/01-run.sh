#!/bin/bash -e

install -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.opencpn"
install -o 1000 -g 1000  -v files/opencpn.conf    "${ROOTFS_DIR}/home/pi/.opencpn/"
