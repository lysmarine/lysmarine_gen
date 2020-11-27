#!/bin/bash
source lib.sh

baseOS='debian-vbox'
cpuArch='amd64'
cacheDir="./cache/$baseOS-$cpuArch"
workDir="./work/$baseOS-$cpuArch"
releaseDir="./release/"

sudo mkdir -p $cacheDir
sudo mkdir -p $workDir
sudo mkdir -p $releaseDir
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $cacheDir"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $workDir"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $releaseDir"

if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
	wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-10.6.0-$cpuArch-standard+nonfree.iso"
	mv "$cacheDir/debian-live-10.6.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"
fi
echo ./$workDir/lysmarine_dev_box.vdi
if [[ ! -f ./$workDir/lysmarine_dev_box.vdi ]]; then
	log "Creating a new VBox image"

	#$ VBoxManage convertfromraw --format VDI /media/backup.img /media/backup.vdi

	pushd ./$workDir/
		log "Creating VBox image"

		# create the machine
		VBoxManage createvm --name lysmarine_dev_box --ostype "Debian_64" --register --basefolder ./

		#Set memory and network
		VBoxManage modifyvm lysmarine_dev_box --ioapic on
		VBoxManage modifyvm lysmarine_dev_box --memory 2048 --vram 128
		VBoxManage modifyvm lysmarine_dev_box --cpus 4
		VBoxManage modifyvm lysmarine_dev_box --nic1 nat

		#Create Disk and load the iso file
		log "Creating VBox drive"
		VBoxManage createhd --filename ./lysmarine_dev_box.vdi --size 32768
		VBoxManage storagectl lysmarine_dev_box --name "SATA Controller" --add sata --controller IntelAhci
		VBoxManage storageattach lysmarine_dev_box --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ./lysmarine_dev_box.vdi
		VBoxManage storagectl lysmarine_dev_box --name "IDE Controller" --add ide --controller PIIX4
		VBoxManage storageattach lysmarine_dev_box --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium .././$cacheDir/$baseOS-$cpuArch.base.iso
		VBoxManage modifyvm lysmarine_dev_box --boot1 dvd --boot2 disk

		#Start the VM
	#	log "Start the machine for base install"
	#	VBoxManage startvm lysmarine_dev_box --type=gui
	#
	#	#remove the CD
	#	read -n 1 -r -s -p $'When done with the vurtual machine, press enter to continue...\n'
	#
	#	VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 0 --device 0 --medium none
	#	VBoxManage modifyvm $MACHINENAME --boot1 disk --boot2 none
	#	VBoxManage storagectl $MACHINENAME --name "IDE Controller" --remove
	popd

	#Start the VM
	log "Start the machine "
	VBoxManage startvm lysmarine_dev_box --type=gui
#
	cp -v ./work/$thisArch/$thisArch.vdi ./cache/$thisArch/$thisArch.vdi
else
	log "Using VBox image found in cache."
fi

#cp -v ./cache/$thisArch/$thisArch.vdi ./work/$thisArch/$thisArch.vdi
#
#log "Mounting Vbox drive on host And copy lysmarine into it."
## mount and add lysmarine scripts.
#modprobe nbd
#qemu-nbd -v -c /dev/nbd1 ./work/$thisArch/$thisArch.vdi &
#sleep 1
#mount -v /dev/nbd1p1 ./work/$thisArch/rootfs
#
#log "Copy lysmarine"
#addLysmarineScripts $thisArch
#
#log "UNmount"
#umount ./work/$thisArch/rootfs
#qemu-nbd -d /dev/nbd1
#
#echo ""
#echo ""
#echo ""
#echo ""
#echo ""
#echo "========================================================================="
#echo "cd /install-scripts; ./install.sh 1 2 3 4 5 6 7 86 9"
#echo "cd /install-scripts; ./install.sh "
#echo "========================================================================="
#echo ""
#echo ""
#echo ""
#echo ""
#echo ""
#
#VBoxManage startvm $MACHINENAME --type=gui
#read -n 1 -r -s -p $'When done with the virtual machine, press enter to continue...\n'
#
##./work/$thisArch/$thisArch.vdi
#
## Renaming the OS and moving it to the release folder.
#cp -v ./work/$thisArch/$thisArch.vdi ./release/LysMarine_$thisArch-0.9.0.vdi
#
#log "DONE."
#
#log "Pro Tip"
#echo ""
#echo "cp -v ./work/$thisArch/$thisArch.vdi ./cache/$thisArch/$thisArch.vdi"
#echo ""
#exit
