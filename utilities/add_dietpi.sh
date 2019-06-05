#!/bin/bash
source ./../lib.sh

dpi="/var/www/LM/DietPi"
mkdir ../work/addDpi
work="../work/addDpi/"

if [ "$1" == "1" ]; then
        IMAGE="DietPi_RPi-ARMv6-Stretch.img"
        thisArch="RPi-ARMv6"

elif [ "$1" == "2" ] ; then
        IMAGE="DietPi_NativePC-BIOS-x86_64-Stretch.img"
        thisArch="NativePC-BIOS-x86_64"

else
        IMAGE="DietPi_RPi-ARMv6-Stretch.img"
        thisArch="RPi-ARMv6"

fi



cp "../cache/$thisArch/$IMAGE"   "$work/$IMAGE"
echo $work/$IMAGE



ROOTFS="$work/rootfs"
BOOTFS="$work/rootfs/boot"

mkdir -p $ROOTFS
mkdir -p $BOOTFS

#mount partitions
mount_image $work/$IMAGE $BOOTFS $ROOTFS

cp -rvf $dpi/rootfs/* $ROOTFS/
echo '=========='
cp -rvf $dpi/dietpi $BOOTFS

umount_image $IMAGE $BOOTFS $ROOTFS
echo
echo "==============================================================="
echo "sudo dd if=$IMAGE of=/dev/mmcblk0 ; sync"
echo "sudo truncate -s 2.5G  $IMAGE; sudo ./bootInQemu.sh $thisArch $IMAGE"
echo "==============================================================="
echo
