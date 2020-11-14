#!/bin/bash
source lib.sh

dBootArch="amd64"
thisArch="debian-$dBootArch"
imageName="$thisArch.img"

checkRoot

get3rdPartyAssets

createEmptyImageFile

setupWorkSpace $thisArch

if [ ! -f ./cache/$thisArch/$imageName-inflated ]; then
	log "No ready-to-buld image found in cache, bootstrapping"

	cp -v ./cache/emptyImage.img ./work/$thisArch/$imageName

	mountImageFile $thisArch ./work/$thisArch/$imageName

	#linux-image-arm64 \
	debootstrap \
		--include=aptitude,console-setup,locales,keyboard-configuration,command-not-found,bash,sudo,intel-microcode,firmware-linux-free,firmware-misc-nonfree,firmware-iwlwifi,cryptsetup,network-manager,initramfs-tools, \
		--exclude=vim \
		--components=main,contrib,non-free \
		--arch amd64 \
		buster \
		./work/$thisArch/rootfs

	umountImageFile $thisArch ./work/$thisArch/$imageName

	mv -vf ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-inflated

else
	log "Using ready to buld image from cache"
fi

cp -fv ./cache/$thisArch/$imageName-inflated ./work/$thisArch/$imageName

# Mount the image and make the binds required to chroot.
mountImageFile $thisArch ./work/$thisArch/$imageName

# Copy the lysmarine and origine OS config files in the mounted rootfs
addLysmarineScripts $thisArch

# Chroot into the mounted image.
log "chroot into the image"

echo ""
echo ""
echo ""
echo ""
echo ""
echo "========================================================================="
echo "You are now in the chroot environement."
echo "Start the build script with by pasting the following line in the terminal:"
echo ""
echo "cd /install-scripts; ./install.sh 1 2 3 4 5 6 7 86 9"
echo "cd /install-scripts; ./install.sh "
echo "========================================================================="
echo ""
echo ""

# chroot into the mount image point
proot \
	--root-id \
	--rootfs=work/${thisArch}/rootfs \
	--cwd=/ \
	--mount=/etc/resolv.conf:/etc/resolv.conf \
	--mount=/dev:/dev \
	--mount=/sys:/sys \
	--mount=/proc:/proc \
	--mount=/tmp:/tmp \
	--mount=/run/shm:/run/shm \
	"/bin/bash"

sed -i 's/^#//g' ./work/$thisArch/rootfs/etc/ld.so.preload

## VBOX IMAGE
rm ./release/$thisArch/LysMarine_$thisArch-0.9.0.vdi
VBoxManage convertfromraw --format VDI ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ./release/$thisArch/LysMarine_$thisArch-0.9.0.vdi

## ISO
# mkisofs -o ./release/$thisArch/LysMarine_$thisArch-0.9.0.iso ./work/$thisArch/rootfs
# Unmount

umountImageFile $thisArch ./work/$thisArch/$imageName

# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$imageName ./release/$thisArch/LysMarine_$thisArch-0.9.0.img
log "DONE."

log "Pro Tip:"
echo ""
echo "sudo cp -v ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ./cache/$thisArch/$imageName-inflated"
echo ""
echo "sudo dd of=/dev/mmcblk0 if=./release/LysMarine_$thisArch-0.9.0.img status=progress"
echo ""

exit
