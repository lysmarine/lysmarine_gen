#!/bin/bash
source ../lib.sh


thisArch=NativePC-BIOS-x86_64
debianVersion="Buster"
image=DietPi_$thisArch-$debianVersion.img
dpi="/var/www/LM/DietPi"


# Create folder hierarchy to work with this architecture
        mkdir -p ./cache/$thisArch
        mkdir -p ./work/$thisArch
        mkdir -p ./work/$thisArch/rootfs
        mkdir -p ./work/$thisArch/bootfs
        mkdir -p ./release/$thisArch



# Needed to shrink the image size at the end.
        if [ ! -f ./cache/pishrink.sh ] ; then
                cd ./cache
                wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
                chmod +x pishrink.sh
                cd ..
        fi



# Download or copy the official image from cache
        downloadDietpiImgFor $thisArch $debianVersion

        cp -fv ./cache/$thisArch/$image ./work/$thisArch/$image



# Add temporary add space to the image drive.
        truncate -s "5G" ./work/$thisArch/$image
        partQty=$(sudo fdisk -l ./work/$thisArch/$image | grep -e "^./work/$thisArch/$image"|wc -l  )
        parted ./work/$thisArch/$image --script "resizepart $partQty 100%" ;



# Mount the image and make the binds required to chroot.
        mount_image ./work/$thisArch/$image "./work/$thisArch/rootfs/boot/" "./work/$thisArch/rootfs/"



# Resize the root file system to fill the new drive size;
        loop=$(losetup -j $IMAGE |  cut -d":" -f1 | sed "s/\/dev\/loop//g" ) #
        IFS=$'\n'
        loop=$(echo "${loop[*]}" | sort -nr | head -n1)
        resize2fs /dev/mapper/loop${loop}p$partQty



#Copy the lysmarine and dietpi config files in the mounted rootfs
        log "copying lysmarine and dietpi_configuration_script on the image"
        cp -r -v ../lysmarine ./work/$thisArch/rootfs/
        chmod 0775 ./work/$thisArch/rootfs/lysmarine/*.sh
        chmod 0775 ./work/$thisArch/rootfs/lysmarine/*/*.sh

        cp -rvf $dpi/rootfs/* ./work/$thisArch/rootfs/
        cp -rvf $dpi/dietpi ./work/$thisArch/rootfs/


# Fix the no-dns problem due to the fact that services are not started.
        mv ./work/$thisArch/rootfs/etc/resolv.conf ./work/$thisArch/rootfs/etc/resolv.conf.lysmarinebak
        cp -vf /etc/resolv.conf ./work/$thisArch/rootfs/etc/resolv.conf






#################################################################################
source ./../lib.sh

IMAGE=./work/$thisArch/$image

if [ ! -f "$IMAGE" ]; then
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
        echo "";
        echo "export ARCH=$thisArch ;cd /lysmarine; ./build.sh 00 10 20 50 55 98"
        echo "";

        sudo proot -r $ROOTFS -q qemu-arm -S $ROOTFS

        cd $wd
        sed -i 's/^#//g' $ROOTFS/etc/ld.so.preload


umount_image $IMAGE $BOOTFS $ROOTFS
#################################################################################

































        # The file transfer is done now, unmouting
                mv ./work/$thisArch/rootfs/etc/resolv.conf.lysmarinebak ./work/$thisArch/rootfs/etc/resolv.conf
                umount_image ./work/$thisArch/$image "./work/$thisArch/rootfs/boot/" "./work/$thisArch/rootfs/"



        # Shrink the image size.
                ./cache/pishrink.sh ./work/$thisArch/$image



        # Renaming the OS and moving it to the release folder.
        cp -v ./work/$thisArch/$image  ./release/$thisSbc/LysMarine_$thisSbc-0.9.0.img

        log "DONE."
