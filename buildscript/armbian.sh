#!/bin/bash
source lib.sh

dBootArch="amd64"
thisArch="armbian-$dBootArch"
imageName="$thisArch.img"



checkRoot ;



get3rdPartyAssets ;



createEmptyImageFile ;



setupWorkSpace $thisArch ;



if [ ! -f ./cache/$thisArch/$imageName-rdy2build ] ;then
	log "No ready-to-buld image found in cache, bootstrapping"

	cp -v ./cache/emptyImage.img ./work/$thisArch/$imageName

	mountImageFile $thisArch ./work/$thisArch/$imageName ;



debootstrap \
--arch=$dBootArch \
buster \
./work/$thisArch/rootfs \


#
# 	debootstrap \
# --arch=$dBootArch \
# --include=aptitude,console-setup,locales,keyboard-configuration,build-essential,libc6-dev,\
# command-not-found,busybox,sudo,intel-microcode,firmware-linux-free,firmware-misc-nonfree,\
# firmware-iwlwifi,cryptsetup,network-manager \
# --exclude=vim \
# --components=main,contrib,non-free \
# buster \
# ./work/$thisArch/rootfs

	umountImageFile $thisArch ./work/$thisArch/$imageName

	mv -vf ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-rdy2build

else
	log "Using ready to buld image from cache"
fi;



cp -fv ./cache/$thisArch/$imageName-rdy2build ./work/$thisArch/$imageName



mountImageFile $thisArch ./work/$thisArch/$imageName ;



#  chmod 0775 ./work/$thisArch/rootfs/lysmarine/*.sh
#  chmod 0775 ./work/$thisArch/rootfs/lysmarine/*/*.sh

mkdir ./work/$thisArch/rootfs/lysmarine
mount --bind ../lysmarine ./work/$thisArch/rootfs/lysmarine


# Chroot into the mounted image./
log "chroot into the image"

echo "";echo "";echo "";echo "";echo "";
echo "========================================================================="
echo "You are now in the chroot environement.";
echo "Start the build script with by pasting the following line in the terminal:";
echo "";
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 00 "
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 00 ";
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh ";

echo "========================================================================="
echo "";echo "";


# chroot into the mount image point
 proot -q qemu-i386 \
 	--root-id \
 	--rootfs=work/${thisArch}/rootfs \
	--cwd=/ \
 	--mount=/etc/resolv.conf:/etc/resolv.conf \
 	--mount=/dev:/dev \
 	--mount=/sys:/sys \
 	--mount=/proc:/proc \
 	--mount=/tmp:/tmp \
 	--mount=/run/shm:/run/shm \
 	/bin/sh




sed -i 's/^#//g' ./work/$thisArch/rootfs/etc/ld.so.preload



	umountImageFile $thisArch ./work/$thisArch/$imageName



# Shrink the image size.
./cache/pishrink.sh ./work/$thisArch/$image



# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img
log "DONE."



echo "Pro Tip"
echo "cp -v ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-rdy2build"

exit
