#!/bin/bash
{
source lib.sh

thisArch="armbian-pineA64"
#imageSource="https://dl.armbian.com/pine64so/Buster_current"
imageSource="https://dl.armbian.com/pine64so/archive/Armbian_20.05.2_Pine64so_buster_current_5.4.43.img.xz"
zipName="Armbian_20.05.2_Pine64so_buster_current_5.4.43.img.xz"
imageName="Armbian_20.05.2_Pine64so_buster_current_5.4.43.img"


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
	rm ./cache/$thisArch/$zipName

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
echo "cd /lysmarine; ./build.sh 1 2 3 4 5 6 7 86 9"
echo "cd /lysmarine; ./build.sh ";
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
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img



log "Pro Tip:"
echo ""
echo "sudo cp -v ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ./cache/$thisArch/$imageName-inflated"
echo ""
echo "sudo dd of=/dev/mmcblk0 if=./release/$thisArch/LysMarine_$thisArch-0.9.0.img status=progress"
echo ""

exit
}
