#!/bin/bash
source common.sh



thisArch=BIOS-x86_64
imageSource="https://dietpi.com/downloads/images/"
zipName="DietPi_NativePC-BIOS-x86_64-Buster.7z"
imageName="DietPi_v6.25_NativePC-BIOS-x86_64-Buster.img"
dietPiRepo="https://github.com/MichaIng/DietPi"
dietPiBranch="dev"

DBOOTmirror="http://ftp.debian.org/debian/"
DBOOTinclude="net-tools,isc-dhcp-client,nano,openssh-server,rsync,wget"
DBOOTaptsources="deb deb.debian.org/debian/ buster main contrib non-free \ndeb-src https://deb.debian.org/debian/ buster main contrib non-free"
DBOOTarch='amd64'


# Create caching folder hierarchy to work with this architecture
setupWorkSpace $thisArch



# Check 3rd party dependency Needed to to execute various tasks .
getCachedVendors



# Update and checkout the good branch of the repository
cd ./cache/DietPi/
git checkout $dietPiBranch
git pull
cd ../../



# Copy image file to work folder add temporary space to it.
prepareBaseOs


# copy ready image from cache to the work dir
cp -fv ./cache/$thisArch/$imageName-rdy2build ./work/$thisArch/$imageName



# Mount the image and make the binds required to chroot.
mountAndBind



# Copy the lysmarine and dietpi config files in the mounted rootfs
addScripts


# chroot into the mounted image.
log "chroot into the image"

echo "";echo "";echo "";echo "";echo "";
echo "========================================================================="
echo "You are now in the chroot environement.";
echo "Start the build script with by pasting the following line in the terminal:";
echo "";
echo "export ARCH=$thisArch ;cd /lysmarine; ./build.sh 00 10 50 51 55 98; exit"
echo "export ARCH=RPi-ARMv6 ;cd /lysmarine; ./build.sh 00 10 20 21 22 26 27 30 31 32 50 51 52 55 98 ";
echo "export ARCH=RPi-ARMv6 ;cd /lysmarine; ./build.sh ";

echo "========================================================================="
echo "";echo "";

cmds='/bin/bash -e ' # drop to shell prompt
sudo proot -r ./work/$thisArch/rootfs -q qemu-aarch64 -S ./work/$thisArch/rootfs ;

sed -i 's/^#//g' ./work/$thisArch/rootfs/etc/ld.so.preload



#unmount
unmountOs



# Shrink the image size.
# ./cache/pishrink.sh ./work/$thisArch/$image



# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img
log "DONE."



echo "Pro Tip"
echo "cp -v ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-rdy2build"

exit
