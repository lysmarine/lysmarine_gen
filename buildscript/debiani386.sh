#!/bin/bash
source common.sh


thisArch=debian-i386
imageSource="https://cdimage.debian.org/debian-cd/current/i386/iso-cd/debian-10.1.0-i386-netinst.iso"
zipName="NONEVOID"
imageName="debian-10.1.0-i386-netinst.iso"



# Create caching folder hierarchy to work with this architecture
setupWorkSpace $thisArch



# Check 3rd party dependency Needed to to execute various tasks .
getCachedVendors



log "Extract iso file"
mount -o ./cache/$thisArch/$imageName ./work/$thisArch/ISOmountPoint
cp -r ./work/$thisArch/ISOmountPoint/*  ./files/preseed.cfg ./work/$thisArch/rootfs
umount ./work/$thisArch/mountPoint



log "Inject preseed file"
cp -v ./files/preseed.cfg ./work/$thisArch/rootfs/preseed.cfg
gunzip ./work/$thisArch/rootfs/install.386/initrd.gz
echo ./work/$thisArch/rootfs/preseed.cfg | cpio -H newc -o -A -F ./work/$thisArch/rootfs/install.386/initrd
gzip ./work/$thisArch/rootfs/install.386/initrd
chmod -w -R ./work/$thisArch/rootfs/install.386/



# Inject lysmarine build script
# cp -rv ../lysmarine ./work/$thisArch/rootfs/



log "Recreate new iso file"
chmod -R -w ./work/$thisArch/rootfs
dd if=./cache/$thisArch/$imageName bs=1 count=432 of=./work/$thisArch/isohdpfx.bin

xorriso -as mkisofs -o ./work/$thisArch/preseeded.iso \
-isohybrid-mbr ./work/$thisArch/isohdpfx.bin \
-c isolinux/boot.cat -b isolinux/isolinux.bin \
-no-emul-boot -boot-load-size 4 -boot-info-table ./work/$thisArch/rootfs

log "Boot in qemu"
qemu-img create -f raw ./work/$thisArch/qemuImage.img 5G

export QEMU_FLAGS=(qemu-system-x86_64
		-m 1512 \
		-no-reboot \
		-serial stdio \
		-boot d \
		-cdrom "./work/$thisArch/preseeded.iso" \
		-drive file=./work/$thisArch/qemuImage.img,index=0,media=disk,format=raw \
		-net user,hostfwd=tcp::${#1}${#2}2-:22 \
		-net nic
		)

"${QEMU_FLAGS[@]}"

exit

# Mount the image and make the binds required to chroot.
mountAndBind



# Copy the lysmarine and origin OS config files in the mounted rootfs
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
