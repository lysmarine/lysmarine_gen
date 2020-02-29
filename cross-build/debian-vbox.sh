#!/bin/bash
source lib.sh

thisArch="debian-vbox"
MACHINENAME=lysmarine
imageName="$thisArch.img"
# Download or copy the official image from cache


checkRoot ;



createEmptyImageFile ;



setupWorkSpace $thisArch ;



if [ ! -f ./cache/$thisArch/$imageName-inflated ] ;then
	log "No ready-to-buld image found in cache, bootstrapping"

	cp -v ./cache/emptyImage.img ./work/$thisArch/$imageName

	mountImageFile $thisArch ./work/$thisArch/$imageName ;

	qemu-debootstrap --arch amd64 --components "main,contrib,non-free" --no-check-gpg --include "net-tools,isc-dhcp-client,nano,wget,bash,ca-certificates,lsb-release" buster ./work/$thisArch/rootfs
ls -lah work/${thisArch}/rootfs
	umountImageFile $thisArch ./work/$thisArch/$imageName

	mv -vf ./work/$thisArch/$imageName ./cache/$thisArch/$imageName-inflated

else
	log "Using ready to buld image from cache"
fi;



cp -vf ./cache/$thisArch/$imageName-inflated ./work/$thisArch/$imageName 



# Mount the image and make the binds required to chroot.
mountImageFile $thisArch ./work/$thisArch/$imageName ;



# Copy the lysmarine and origine OS config files in the mounted rootfs
addLysmarineScripts $thisArch



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



umountImageFile $thisArch ./work/$thisArch/$imageName






if [ ! -f ./cache/$thisArch/$thisArch.vdi ]; then
	log "No virtualbox machine found. Creating one"
	rm /root/.config/VirtualBox/lysmarine/lysmarine.vbox
	
	#Create VM
	pushd ./work/$thisArch/
		log "Creating VBox Machine"
		VBoxManage createvm --name $MACHINENAME --register --ostype "Debian_64" --basefolder ./
		VBoxManage modifyvm $MACHINENAME --ioapic on
		VBoxManage modifyvm $MACHINENAME --memory 2048 --vram 128
		VBoxManage modifyvm $MACHINENAME --cpus 4
		VBoxManage modifyvm $MACHINENAME --nic1 nat


		## Convert image file to vbox drive
		log "Converting Image file"
		VBoxManage convertfromraw ./../../cache/$thisArch/$imageName-inflated ./$thisArch.vdi --format vdi

		## Atach the drive to the machine
		log "Attach the drive to the Machine"
		VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci --bootable on
		VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  ./$thisArch.vdi
		VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none

	popd
    cp -v ./work/$thisArch/$thisArch.vdi ./cache/$thisArch/$thisArch.vdi  
else
	log "Using VBox image found in cache."
fi



cp -v  ./cache/$thisArch/$thisArch.vdi ./work/$thisArch/$thisArch.vdi  

log "Mounting Vbox drive on host And copy lysmarine into it."
# mount and add lysmarine scripts.
modprobe nbd
qemu-nbd  -v -c /dev/nbd0 ./work/$thisArch/$thisArch.vdi & 
sleep 1 
mount /dev/nbd0p1 ./work/$thisArch/rootfs

log "Copy lysmarine"
addLysmarineScripts $thisArch		


log "UNmount"
umount ./work/$thisArch/rootfs
qemu-nbd -d /dev/nbd0

echo "";echo "";echo "";echo "";echo "";
echo "========================================================================="
echo "cd /lysmarine; ./build.sh 1 2 3 4 5 6 7 86 9"
echo "cd /lysmarine; ./build.sh ";
echo "========================================================================="
echo "";echo "";echo "";echo "";echo "";

VBoxManage startvm $MACHINENAME --type=gui
read -n 1 -r -s -p $'When done with the vurtual machine, press enter to continue...\n'

./work/$thisArch/$thisArch.vdi

# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$thisArch.vdi  ./release/$thisArch/LysMarine_$thisArch-0.9.0.vdi
log "DONE."

log "Pro Tip"
echo "" 
echo "cp -v ./work/$thisArch/$thisArch.vdi ./cache/$thisArch/$thisArch.vdi"
echo ""
exit
