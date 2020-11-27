#!/bin/bash -xe
source lib.sh

baseOS='debian-vbox'
cpuArch='amd64'
cacheDir="./cache/$baseOS-$cpuArch"
workDir="./work/$baseOS-$cpuArch"
releaseDir="./release/"

sudo mkdir -p $cacheDir
sudo mkdir -p $workDir
sudo mkdir -p $workDir/rootfs
sudo mkdir -p $releaseDir
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $cacheDir"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $workDir"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $workDir/rootfs"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $releaseDir"

if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
	wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-10.6.0-$cpuArch-standard+nonfree.iso"
	mv "$cacheDir/debian-live-10.6.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"
fi

if [[ ! -f ./$cacheDir/lysmarine_dev_box.vdi ]]; then
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
		VBoxManage storageattach lysmarine_dev_box --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ../.././$cacheDir/$baseOS-$cpuArch.base.iso
		VBoxManage modifyvm lysmarine_dev_box --boot1 dvd --boot2 disk

		#Start the VM
		log "This is your first run, Install base debian and rerun this script."
		VBoxManage startvm lysmarine_dev_box --type=gui



		read -n 1 -r -s -p $'When done with the vurtual machine, press enter to continue...\n'
		VBoxManage modifyvm lysmarine_dev_box --boot1 disk --boot2 none
		VBoxManage storagectl lysmarine_dev_box --name "IDE Controller" --remove
	popd

	mv -v $workDir/lysmarine_dev_box.vdi $cacheDir/lysmarine_dev_box.vdi
	exit 0
fi


rsync -auz $cacheDir/lysmarine_dev_box.vdi $workDir/lysmarine_dev_box.vdi

log "Mounting Vbox drive on host And copy lysmarine into it."
sudo modprobe nbd
sudo qemu-nbd -v -c /dev/nbd1 ./$workDir/lysmarine_dev_box.vdi &
sleep 1
sudo mount -v /dev/nbd1p1 ./$workDir/rootfs

	log "copying lysmarine on the image"
	sudo cp -r "../install-scripts" "./$workDir/rootfs/"
	sudo chmod 0775 "./$workDir/rootfs/install-scripts/install.sh"

sudo umount ./$workDir/rootfs
sudo qemu-nbd -d /dev/nbd1


	log "Start the machine "
	VBoxManage startvm lysmarine_dev_box --type=gui
