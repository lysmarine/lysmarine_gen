#!/bin/bash
{
source common.sh

thisArch=raspbian
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



# Display build tips
echo "";echo "";echo "";echo "";echo "";
echo "========================================================================="
echo "You are now in the chroot environement.";
echo "Start the build script with by pasting one of the following line in the terminal:";
echo "";
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 10 20 21 23 "
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 50 51 52 53 55 98"
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 86 87"
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 30 32 32 "
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 40 45 46 "
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 22";
echo "========================================================================="
echo "";echo "";



# chroot into the
 proot -q qemu-arm \
 	--root-id \
 	--rootfs=work/${thisArch}/rootfs \
	--cwd=/ \
 	--mount=/etc/resolv.conf:/etc/resolv.conf \
 	--mount=/dev:/dev \
 	--mount=/sys:/sys \
 	--mount=/proc:/proc \
 	--mount=/tmp:/tmp \
 	--mount=/run/shm:/run/shm \
 	/bin/bash -e



# Unmount
unmountOs



# Shrink the image size.
./cache/pishrink.sh ./work/$thisArch/$imageName



# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img



exit
}
