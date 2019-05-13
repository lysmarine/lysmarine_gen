#!/bin/bash
source ./lib.sh

if [ -z "$1" ]; then
        logError "Please specify the architecture ( RPi-ARMv6 )"; exit 1 ;
fi

thisArch=$1
debianVersion="Stretch"
image=DietPi_$thisArch-$debianVersion.img

# create hierarchy to work with this architecture
mkdir -p ./cache/$thisArch
mkdir -p ./work/$thisArch
mkdir -p ./work/$thisArch/rootfs
mkdir -p ./work/$thisArch/bootfs
mkdir -p ./release/$thisArch

# download or copy the official image from cache
downloadDietpiImgFor $thisArch $debianVersion
cp -fv ./cache/$thisArch/$image ./work/$thisArch/$image

# add space to the image drive
truncate -s "5G" ./work/$thisArch/$image
partQty=$(sudo fdisk -l ./work/$thisArch/$image | grep -e "^./work/$thisArch/$image"|wc -l  )
parted ./work/$thisArch/$image --script "resizepart $partQty 100%" ;

# mount the image and make the binds required to chroot.
mount_image ./work/$thisArch/$image "./work/$thisArch/rootfs/boot/" "./work/$thisArch/rootfs/"

# resize the root file system to fill the new drive size;
loop=$(losetup -j $IMAGE |  cut -d":" -f1 | sed "s/\/dev\/loop//g" ) #
IFS=$'\n'
loop=$(echo "${loop[*]}" | sort -nr | head -n1)
resize2fs /dev/mapper/loop${loop}p$partQty

#Copy the lysmarine and dietpi config files in the mounted rootfs
log "copying lysmarine and dietpi_configuration_script on the image"
cp -r lysmarine ./work/$thisArch/rootfs/
cp -r dietpi_configuration_script ./work/$thisArch/rootfs/
chmod 0775 ./work/$thisArch/rootfs/lysmarine/*.sh
chmod 0775 ./work/$thisArch/rootfs/lysmarine/*/*.sh
chmod 0775 ./work/$thisArch/rootfs/dietpi_configuration_script/*.sh

# Fix the no-dns problem due to the fact that services are not started.
mv ./work/$thisArch/rootfs/etc/resolv.conf ./work/$thisArch/rootfs/etc/resolv.conf.lysmarinebak
cp -vf /etc/resolv.conf ./work/$thisArch/rootfs/etc/resolv.conf

# Define the commands to pass to the chroot environement
cmds=" export ARCH=$thisArch ;cd /lysmarine; ./build.sh; exit 0 "
 #cmds='/bin/bash' # drop to shell prompt

on_chroot $thisArch "$(pwd)/work/$thisArch/rootfs/" "${cmds[@]}"

# The file transfer is done now, unmouting
mv ./work/$thisArch/rootfs/etc/resolv.conf.lysmarinebak ./work/$thisArch/rootfs/etc/resolv.conf
umount_image ./work/$thisArch/$image "./work/$thisArch/rootfs/boot/" "./work/$thisArch/rootfs/"

#shrink the image size
if [ ! -f ./cache/pishrink ] ; then
        cd ./cache
        wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
        chmod +x pishrink.sh
        cd ..
fi
./cache/pishrink.sh ./work/$thisArch/$image

# renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$image  ./release/$thisSbc/LysMarine_$thisSbc-0.9.0.img

log "DONE."
# read -n 1 -s -r -p " .-=|~| PAUSE |~|=-."
