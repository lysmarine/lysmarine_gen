#!/bin/bash -xe
{
source lib.sh

myCpuArch=$1
thisArch="raspbian"
cpuArch="armhf"
if [ "arm64" == "$myCpuArch" ]; then
  cpuArch="arm64"
fi
zipName="raspios_lite_${cpuArch}_latest"
imageSource="https://downloads.raspberrypi.org/${zipName}"

checkRoot

# Create caching folder hierarchy to work with this architecture.
setupWorkSpace $thisArch

# Download the official image
log "Downloading official image from internet."
wget -P ./cache/$thisArch/ $imageSource
7z e -o./cache/$thisArch/ ./cache/$thisArch/$zipName
rm ./cache/$thisArch/$zipName

# Copy image file to work folder add temporary space to it.
imageName=$(cd ./cache/$thisArch; ls *.img; cd ../../)
inflateImage $thisArch ./cache/$thisArch/$imageName

# copy ready image from cache to the work dir
cp -fv ./cache/$thisArch/$imageName-inflated ./work/$thisArch/$imageName

# Mount the image and make the binds required to chroot.
mountImageFile $thisArch ./work/$thisArch/$imageName

# Copy the lysmarine and origine OS config files in the mounted rootfs
addLysmarineScripts $thisArch

# Display build tips
echo "You are now in the chroot environement."
echo "Start the build script with by pasting one of the following line in the terminal:"
echo "cd /lysmarine; ./install.sh 1 2 3 4 5 6 7 86 9"
echo "cd /lysmarine; ./install.sh "
echo ""

# chroot into the
#proot -q qemu-arm \
#	--root-id \
#	--rootfs=work/${thisArch}/rootfs \
#	--cwd=/ \
#	--mount=/etc/resolv.conf:/etc/resolv.conf \
#	--mount=/dev:/dev \
#	--mount=/sys:/sys \
#	--mount=/proc:/proc \
#	--mount=/tmp:/tmp \
#	--mount=./cache/$thisArch/stageCache:/lysmarine/stageCache \
#	--mount=/run/shm:/run/shm \
#	/bin/bash

ls -l /run

MK_ROOT=work/${thisArch}/rootfs
mkdir -p ./cache/${thisArch}/stageCache; mkdir -p $MK_ROOT/lysmarine/stageCache
mkdir -p /run/shm; mkdir -p $MK_ROOT/run/shm
mount -o bind /etc/resolv.conf $MK_ROOT/etc/resolv.conf
mount -o bind /dev $MK_ROOT/dev
mount -o bind /sys $MK_ROOT/sys
mount -o bind /proc $MK_ROOT/proc
mount -o bind /tmp $MK_ROOT/tmp
mount --rbind ./cache/$thisArch/stageCache $MK_ROOT/lysmarine/stageCache
mount --rbind /run/shm $MK_ROOT/run/shm
chroot work/${thisArch}/rootfs /bin/bash -xe << EOF > /tmp/lysmarine-mk-image.log
  set -x; set -e; cd /lysmarine; export LMBUILD="raspbian"; ls; chmod +x *.sh; ./install.sh; exit
EOF

# Unmount
umountImageFile $thisArch ./work/$thisArch/$imageName

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
