#!/bin/bash
source lib.sh

thisArch="debian-vbox"
imageSource="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.2.0-amd64-netinst.iso"
isoName="debian-10.2.0-amd64-netinst.iso"
MACHINENAME=lysmarine
# Download or copy the official image from cache

checkRoot ;
setupWorkSpace $thisArch ;


if [ ! -f ./cache/$thisArch/$isoName ]; then
	log "Downloading official ISO from internet."
	wget -P ./cache/$thisArch/  $imageSource
else
	log "Using official ISO from cache."

fi



if [ ! -f ./cache/$thisArch/$thisArch.vdi ]; then
	log "Creating a new VBox image"

	#Create VM
	VBoxManage createvm --name $MACHINENAME --ostype "Debian_64" --register --basefolder $(pwd)/work/$thisArch/

	#Set memory and network
	VBoxManage modifyvm $MACHINENAME --ioapic on
	VBoxManage modifyvm $MACHINENAME --memory 2048 --vram 128
	VBoxManage modifyvm $MACHINENAME --cpus 4
	VBoxManage modifyvm $MACHINENAME --nic1 nat

	#Create Disk and connect Debian Iso
	rm ./work/$thisArch/$thisArch.vdi
	VBoxManage createhd --filename ./work/$thisArch/$thisArch.vdi --size 32768
	VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
	VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  ./work/$thisArch/$thisArch.vdi
	VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
	VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ./cache/$thisArch/$isoName
	VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none


	#Start the VM
	VBoxManage startvm $MACHINENAME --type=gui


	#remove the CD
	VBoxManage storageattach ./cache/$thisArch/$thisArch.vdi --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium none
	read -n 1 -r -s -p $'Press enter to continue...\n'
    
    cp -v ./work/$thisArch/$thisArch.vdi ./cache/$thisArch/$thisArch.vdi  
else
	log "Using VBox image found in cache."
fi




cp -v  ./cache/$thisArch/$thisArch.vdi ./work/$thisArch/$thisArch.vdi  

log "Mounting Vbox drive on host And copy lysmarine into it."
# mount and add lysmarine scripts.
modprobe nbd
qemu-nbd  -v -c /dev/nbd1 ./work/$thisArch/$thisArch.vdi &
sleep 1 ;
mount /dev/nbd1p1 ./work/$thisArch/rootfs

log "Copy lysmarine"
addLysmarineScripts $thisArch		


	log "UNmount"
umount ./work/$thisArch/rootfs
qemu-nbd -d /dev/nbd1


# VBoxManage internalcommands sethduuid ./work/$thisArch/$thisArch.vdi
# VBoxManage internalcommands sethduuid ./cache/$thisArch/$thisArch.vdi

#VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  none
#VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  ./work/$thisArch/$thisArch.vdi
VBoxManage startvm $MACHINENAME --type=gui

















exit



get3rdPartyAssets ;



createEmptyImageFile ;



setupWorkSpace $thisArch ;



if [ ! -f ./cache/$thisArch/$imageName-inflated ] ;then
	log "No ready-to-buld image found in cache, bootstrapping"

	cp -v ./cache/emptyImage.img ./work/$thisArch/$imageName

	mountImageFile $thisArch ./work/$thisArch/$imageName ;

	debootstrap \
--include=aptitude,console-setup,locales,keyboard-configuration,\
command-not-found,bash,sudo,intel-microcode,firmware-linux-free,firmware-misc-nonfree,\
firmware-iwlwifi,cryptsetup,network-manager,initramfs-tools,linux-image-4.19.0-6-amd64 \
--exclude=vim \
--components=main,contrib,non-free \
--arch amd64 \
buster \
./work/$thisArch/rootfs

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
echo "========================================================================="
echo "You are now in the chroot environement.";
echo "Start the build script with by pasting the following line in the terminal:";
echo "";
echo "apt install initramfs-tools linux-image-4.19.0-6-amd64 "
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh 00 ";
echo "export LMBUILD=$thisArch ;cd /lysmarine; ./build.sh ";

echo "========================================================================="
echo "";echo "";

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
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img
log "DONE."



echo "Pro Tip"
echo "cp -v ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-inflated"

exit
