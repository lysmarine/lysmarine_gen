#!/bin/bash -xe
source lib.sh

baseOS='debian-vbox'
cpuArch='amd64'
cacheDir="./cache/$baseOS-$cpuArch"
workDir="./work/$baseOS-$cpuArch"
releaseDir="./release/"
	buildCmd="./install.sh $1"
	[[ $1 == 'bash' ]] && buildCmd='/bin/bash' ;

sudo mkdir -p $cacheDir
sudo mkdir -p $workDir
sudo mkdir -p $workDir/rootfs
sudo mkdir -p $releaseDir
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $cacheDir"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $workDir"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $workDir/rootfs"
sudo sh -c "chown -R \"\$SUDO_UID:\$SUDO_GID\" $releaseDir"
#if no original ISO
if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
	wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-10.7.0-$cpuArch-standard+nonfree.iso"
	mv "$cacheDir/debian-live-10.7.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"
fi

#if original iso is not extracted
if [[ ! -n "$(ls -A $cacheDir/isoContent/)" ]]; then
	7z x "$cacheDir/${baseOS}-${cpuArch}.base.iso" -o$cacheDir/isoContent
fi

#if no base vbox image exist
if [[ ! -f ./$cacheDir/lysmarine_dev_box.vdi ]]; then
	#generate the modified iso
	rsync -Prq "$cacheDir"/isoContent/ "$workDir/isoContent"
	cp files/preseed.cfg "$workDir/isoContent"
	cp files/splash.png "$workDir/isoContent/isolinux/"
	cp files/menu.cfg "$workDir/isoContent/isolinux/"
	cp files/stdmenu.cfg "$workDir/isoContent/isolinux/"
	xorriso -as mkisofs -V 'lysmarineOSlive-amd64' -o "$cacheDir/vbox.iso" -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus "$workDir/isoContent"


	# create the vbox-machine
	#$ VBoxManage convertfromraw --format VDI /media/backup.img /media/backup.vdi

	pushd ./$workDir/
		log "Creating VBox image"

		# create the machine
		VBoxManage createvm --name lysmarine_dev_box --ostype "Debian_64" --register --basefolder ./

		#port fowarding
		VBoxManage modifyvm lysmarine_dev_box --natpf1 "ssh,tcp,,3022,,22"

		#Set memory and network
		VBoxManage modifyvm lysmarine_dev_box --ioapic on
		VBoxManage modifyvm lysmarine_dev_box --memory 2048 --vram 128
		VBoxManage modifyvm lysmarine_dev_box --cpus 4

		#Create Disk and load the iso file
		log "Creating VBox drive"
		VBoxManage createhd --filename ./lysmarine_dev_box.vdi --size 32768
		VBoxManage storagectl lysmarine_dev_box --name "SATA Controller" --add sata --controller IntelAhci
		VBoxManage storageattach lysmarine_dev_box --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ./lysmarine_dev_box.vdi
		VBoxManage storagectl lysmarine_dev_box --name "IDE Controller" --add ide --controller PIIX4
		VBoxManage storageattach lysmarine_dev_box --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ../.././$cacheDir/vbox.iso
		VBoxManage modifyvm lysmarine_dev_box --boot1 dvd --boot2 disk

		#Start the VM to do the initial install
		log "This is your first run, Install base debian and rerun this script."
		VBoxManage startvm lysmarine_dev_box --type=gui

		read -n 1 -r -s -p $'When done with the vurtual machine, press enter to continue...\n'
		VBoxManage modifyvm lysmarine_dev_box --boot1 disk --boot2 none

	popd

	mv -v $workDir/lysmarine_dev_box.vdi $cacheDir/lysmarine_dev_box.vdi
	exit 0
fi


cp $cacheDir/lysmarine_dev_box.vdi $workDir/lysmarine_dev_box.vdi

log "Mounting Vbox drive on host And copy lysmarine into it."
sudo modprobe nbd
sudo qemu-nbd -v -c /dev/nbd1 ./$workDir/lysmarine_dev_box.vdi &
sleep 1
sudo mount -v /dev/nbd1p1 ./$workDir/rootfs

	# copying lysmarine on the image
	sudo cp -r "../install-scripts" "./$workDir/rootfs/"
	sudo chmod 0775 "./$workDir/rootfs/install-scripts/install.sh"

#		sudo mount --bind /dev $workDir/rootfs/dev
#		sudo mount -t proc /proc $workDir/rootfs/proc
#		sudo mount --bind /sys $workDir/rootfs/sys
#		sudo mount --bind /tmp $workDir/rootfs/tmp
##
#		sudo cp /etc/resolv.conf  $workDir/rootfs/etc/
#		sudo chroot $workDir/rootfs /bin/bash <<EOT
#EOT
#		sudo rm $workDir/rootfs/etc/resolv.conf
#		sudo umount $workDir/rootfs/dev
#		sudo umount $workDir/rootfs/proc
#		sudo umount $workDir/rootfs/sys
#		sudo umount $workDir/rootfs/tmp
#


	sudo umount ./$workDir/rootfs
	sudo qemu-nbd -d /dev/nbd1

	log "Start the machine "
	VBoxManage startvm lysmarine_dev_box --type=gui
