#!/bin/bash
{
source lib.sh

thisArch="armbian-pine64"
imageSource="https://dl.armbian.com/pine64/Buster_current"
zipName="Buster_current"
imageName="Armbian_19.11.3_Pine64_buster_current_5.3.9.img"



checkRoot ;



# Create caching folder hierarchy to work with this architecture.
setupWorkSpace $thisArch ;



# Check 3rd party dependency Needed to to execute various tasks.
get3rdPartyAssets ;



# Download or copy the official image from cache
if [ ! -f ./cache/$thisArch/$imageName ]; then
	log "Downloading official image from internet."
	wget -P ./cache/$thisArch/  $imageSource
	7z e -o./cache/$thisArch/  ./cache/$thisArch/$zipName
	rm ./cache/$thisArch/$zipName ./cache/$thisArch/Armbian_19.11.3_Pine64_buster_current_5.3.9.img.*

else
	log "Using official image from cache."

fi



# Copy image file to work folder add temporary space to it.
inflateImage $thisArch ./cache/$thisArch/$imageName



# copy ready image from cache to the work dir
cp -fv ./cache/$thisArch/$imageName-inflated ./work/$thisArch/$imageName



# Mount the image and make the binds required to chroot.
mountImageFile $thisArch ./work/$thisArch/$imageName



# Copy the lysmarine and origine OS config files in the mounted rootfs
addLysmarineScripts $thisArch


# Chroot into the mounted image./
log "chroot into the image"

echo "";echo "";echo "";echo "";echo "";
echo "========================================================================="
echo "You are now in the chroot environement.";
echo "Start the build script with by pasting the following line in the terminal:";
echo "";
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 10 15 20 21 22 23 "
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 00 ";
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh ";
echo "========================================================================="
echo "";echo "";



# chroot into the mount image point
proot -q qemu-aarch64 \
	--root-id \
	--rootfs=work/${thisArch}/rootfs \
	--cwd=/ \
	--mount=/etc/resolv.conf:/etc/resolv.conf \
	--mount=/dev:/dev \
	--mount=/sys:/sys \
	--mount=/proc:/proc \
	--mount=/tmp:/tmp \
	--mount=/run/shm:/run/shm \
	/bin/bash



# Unmount
umountImageFile $thisArch ./work/$thisArch/$imageName



# Shrink the image size.
#./cache/pishrink.sh ./work/$thisArch/$image



# Renaming the OS and moving it to the release folder.
mv -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img



echo "Pro Tip:"
echo "cp -v ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ./cache/$thisArch/$imageName-inflated"
echo "sudo ./cache/pishrink.sh ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ;sudo dd of=/dev/mmcblk0 if=./release/$thisArch/LysMarine_$thisArch-0.9.0.img status=progress"

exit
}
