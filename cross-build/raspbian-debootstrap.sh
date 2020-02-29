#!/bin/bash
source lib.sh

thisArch="raspbian-debootstrap"
imageName="$thisArch.img"



checkRoot ;



get3rdPartyAssets ;



createEmptyImageFile ;



setupWorkSpace $thisArch ;



if [ ! -f ./cache/$thisArch/$imageName-inflated ] ;then
	log "No ready-to-buld image found in cache, bootstrapping"

	cp -v ./cache/emptyImage.img ./work/$thisArch/$imageName

	mountImageFile $thisArch ./work/$thisArch/$imageName ;

	# TODO: BOOTSTRAP_ARGS+=(--keyring "${STAGE_DIR}/files/raspberrypi.gpg")
	qemu-debootstrap --arch armhf --components "main,contrib,non-free" --no-check-gpg --include "net-tools,isc-dhcp-client,nano,wget,bash,ca-certificates,lsb-release" buster ./work/$thisArch/rootfs http://raspbian.raspberrypi.org/raspbian/

	umountImageFile $thisArch ./work/$thisArch/$imageName

	mv -vf ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-inflated

else
	log "Using ready to buld image from cache"
fi;



cp -fv ./cache/$thisArch/$imageName-inflated ./work/$thisArch/$imageName



# Mount the image and make the binds required to chroot.
mountImageFile $thisArch ./work/$thisArch/$imageName ;



# Copy the lysmarine and origine OS config files in the mounted rootfs
addLysmarineScripts $thisArch



# Chroot into the mounted image.
log "chroot into the image"

echo "";echo "";echo "";echo "";echo "";
log "========================================================================="
echo "apt-get install console-data console-common console-setup tzdata most locales keyboard-configuration";
echo "cd /lysmarine; ./build.sh 1 2 3 4 5 6 7 86 9"
echo "cd /lysmarine; ./build.sh ";
log "========================================================================="
echo "";echo "";



# chroot into the mount image point
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
	"/bin/bash"



# Unmount
umountImageFile $thisArch ./work/$thisArch/$imageName



# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img
log "DONE."



log "Pro Tip:"
echo ""
echo "sudo cp -v ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ./cache/$thisArch/$imageName-inflated"
echo ""
echo "sudo dd of=/dev/mmcblk0 if=./release/$thisArch/LysMarine_$thisArch-0.9.0.img status=progress"
echo ""

exit