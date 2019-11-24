#!/bin/bash
{
source common.sh

thisArch=rpi
imageSource="https://downloads.raspberrypi.org/raspbian_lite_latest"
zipName="raspbian_lite_latest"
imageName="2019-09-26-raspbian-buster-lite.img"



# Create caching folder hierarchy to work with this architecture
setupWorkSpace $thisArch



# Check 3rd party dependency Needed to to execute various tasks .
getCachedVendors



# Copy image file to work folder add temporary space to it.
prepareBaseOs



# copy ready image from cache to the work dir
cp -fv ./cache/$thisArch/$imageName-rdy2build ./work/$thisArch/$imageName



# Mount the image and make the binds required to chroot.
mountAndBind


# Copy the lysmarine and origine OS config files in the mounted rootfs
addScripts


###################cp -v /usr/bin/qemu-arm-static "./work/$thisArch/rootfs/usr/bin"


# Fix the no-dns problem due to the fact that services are not started.
mv ./work/$thisArch/rootfs/etc/resolv.conf ./work/$thisArch/rootfs/etc/resolv.conf.lysmarinebak
cp -vf /etc/resolv.conf ./work/$thisArch/rootfs/etc/resolv.conf



# chroot into the mounted image.
log "chroot into the image"

echo "";echo "";echo "";echo "";echo "";
echo "========================================================================="
echo "You are now in the chroot environement.";
echo "Start the build script with by pasting one of the following line in the terminal:";
echo "";
echo "cd /lysmarine; ./build.sh 10 20 21 22 23 27 30 31 32 91 95 98"
echo "cd /lysmarine; ./build.sh 50 51 52 53 55 98"
echo "cd /lysmarine; ./build.sh 46"
echo "cd /lysmarine; ./build.sh ";
echo "========================================================================="
echo "";echo "";

sudo proot -r ./work/$thisArch/rootfs -q qemu-arm -S ./work/$thisArch/rootfs ;

sed -i 's/^#//g' ./work/$thisArch/rootfs/etc/ld.so.preload



#unmount
unmountOs
# Shrink the image size.
# ./cache/pishrink.sh ./work/$thisArch/$image



# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img
log "DONE."



echo "Pro Tips"
echo "sudo cp -v ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-rdy2build"
echo "sudo dd of=/dev/mmcblk0 if=./release/$thisArch/LysMarine_$thisArch-0.9.0.img status=progress"
exit
}
