#!/bin/bash
source ./../lib.sh

thisArch=$1
IMAGE=$2

if [ ! -f "$2" ]; then
      echo "Plz provide an existing image file to chroot into"
      exit
fi

ROOTFS="../work/util_$thisArch/rootfs"
BOOTFS="../work/util_$thisArch/rootfs/boot"

mkdir -p $ROOTFS
mkdir -p $BOOTFS


#mount partitions
mount_image $IMAGE $BOOTFS $ROOTFS
cmds='/bin/bash -e ' # drop to shell prompt





        # ld.so.preload fix
        sed -i 's/^/#/g' $ROOTFS/etc/ld.so.preload

        # copy qemu binary
        cp /usr/bin/qemu-arm-static $ROOTFS/usr/bin/

        wd=$(pwd)
        cd $ROOTFS
        sudo proot -r $ROOTFS -q qemu-arm -S $ROOTFS

        cd $wd
        sed -i 's/^#//g' $ROOTFS/etc/ld.so.preload


umount_image $IMAGE $BOOTFS $ROOTFS
