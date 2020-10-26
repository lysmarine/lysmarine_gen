log () {
	echo -e "\e[32m["$(date +'%T' )"] \e[1m $1 \e[0m"
}

logErr () {
	echo -e "\e[91m ["$(date +'%T' )"] ---> $1 \e[0m"
}

# Create caching folder hierarchy to work with this architecture
setupWorkSpace () {
	thisArch=$1
	mkdir -p ./cache/$thisArch/stageCache
	mkdir -p ./work/$thisArch/rootfs
	mkdir -p ./work/$thisArch/bootfs
	mkdir -p ./release/$thisArch
}

# Check if the user run with root privileges
checkRoot () {
	if [ $EUID -ne 0 ]; then
		echo "This tool must be run as root."
		exit 1
	fi
}

# Validate cache or download all the needed scripts from 3rd partys
get3rdPartyAssets () {
	true
}

createEmptyImageFile () {
	if [ ! -f ./cache/emptyImage.img ]; then
		log "Create empty image file with qemu"
		qemu-img create -f raw ./cache/emptyImage.img 7G
		echo -e "o\nn\np\n1\n2048\n+300M\nn\np\n2\n\n\na\n1\nw\n" | fdisk ./cache/emptyImage.img

		loopId=$(kpartx -sav ./cache/emptyImage.img |  cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)

		mkfs.fat -n boot -F 32 /dev/mapper/loop${loopId}p1
		mkfs.ext4 /dev/mapper/loop${loopId}p2

		kpartx -d ./cache/emptyImage.img
	else
		log "Using empty image from cache"
	fi
}

mountImageFile () {
	thisArch=$1
	imageFile=$2

	log "Mounting Image File"

	## Make sure it's not already mounted
	if [ -n "$(ls -A ./work/$thisArch/rootfs)" ]; then
		logErr "./work/$thisArch/rootfs is not empty. Previous failure to unmount?"
		umountImageFile $1 $2
		exit
	fi

	# Mount the image and make the binds required to chroot.
	IFS=$'\n' #to split lines into array
	partitions=$(kpartx -sav $imageFile |  cut -d" " -f3)
	partQty=${#partitions[@]}
	echo $partQty partitions detected.

	# mount partition table in /dev/loop
	loopId=$(kpartx -sav $imageFile |  cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)

	if [ $partQty == 2 ]; then
		mount -v /dev/mapper/loop${loopId}p2 ./work/$thisArch/rootfs/
		if [ ! -d ./work/$thisArch/rootfs/boot ]; then mkdir ./work/$thisArch/rootfs/boot; fi
		mount -v /dev/mapper/loop${loopId}p1 ./work/$thisArch/rootfs/boot/
	elif [ $partQty == 1 ]; then
		mount -v /dev/mapper/loop${loopId}p1 ./work/$thisArch/rootfs/
	else
		log "ERROR: unsuported amount of partitions."
		exit 1
	fi
}

umountImageFile () {
	log "un-Mounting"
	thisArch=$1
	imageFile=$2

	rm -rf ./work/${thisArch}/rootfs/home/border
	rm -rf ./work/${thisArch}/rootfs/lysmarine
	rm -rf ./work/${thisArch}/rootfs/var/log/*
	rm -rf ./work/${thisArch}/rootfs/tmp/*

	umount ./work/$thisArch/rootfs/boot
	umount ./work/$thisArch/rootfs
	kpartx -d $imageFile
}

inflateImage () {
	thisArch=$1
	imageLocation=$2

	if [ ! -f $imageLocation-inflated ]; then
		log "Inflating OS image to have enough space to build lysmarine. "
		cp -fv $imageLocation $imageLocation-inflated

		log "truncate image to 7G"
		truncate -s "7G" $imageLocation-inflated

		log "resize last partition to 100%"
		partQty=$(fdisk -l $imageLocation-inflated | grep -o "^$imageLocation-inflated" | wc -l)
		parted $imageLocation-inflated --script "resizepart $partQty 100%" ;
		fdisk -l $imageLocation-inflated

		log "Resize the filesystem to fit the partition."
		loopId=$(kpartx -sav $imageLocation-inflated | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)
		sleep 5
		ls -l /dev/mapper/

		e2fsck -f /dev/mapper/loop${loopId}p$partQty
		resize2fs /dev/mapper/loop${loopId}p$partQty
		kpartx -d $imageLocation-inflated
	else
		log "Using Ready to build image from cache"
	fi
}

function addLysmarineScripts {
	thisArch=$1
	log "copying lysmarine on the image"
	mkdir -p ./work/$thisArch/rootfs/install-scripts
	cp -r ../install-scripts ./work/$thisArch/rootfs/
	chmod 0775 ./work/$thisArch/rootfs/install-scripts/install.sh
}
