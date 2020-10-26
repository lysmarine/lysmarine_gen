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
		emptyImg=./cache/emptyImage.img
		qemu-img create -f raw $emptyImg 7G
		echo -e "o\nn\np\n1\n2048\n+300M\nn\np\n2\n\n\na\n1\nw\n" | fdisk $emptyImg

		loopId=$(kpartx -sav $emptyImg |  cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)

		mkfs.fat -n boot -F 32 /dev/mapper/loop${loopId}p1
		mkfs.ext4 /dev/mapper/loop${loopId}p2

		kpartx -d $emptyImg
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
	rootfs=./work/${thisArch}/rootfs

	rm -rf $rootfs/home/border
	rm -rf $rootfs/lysmarine
	rm -rf $rootfs/var/log/*
	rm -rf $rootfs/tmp/*

	umount $rootfs/boot
	umount $rootfs
	kpartx -d $imageFile
}

inflateImage () {
	thisArch=$1
	imageLocation=$2
	imageLocationInflated=${imageLocation}-inflated

	if [ ! -f $imageLocationInflated ]; then
		log "Inflating OS image to have enough space to build lysmarine. "
		cp -fv ${imageLocation} $imageLocationInflated

		log "truncate image to 7G"
		truncate -s "7G" $imageLocationInflated

		log "resize last partition to 100%"
		partQty=$(fdisk -l $imageLocationInflated | grep -o "^$imageLocationInflated" | wc -l)
		parted $imageLocationInflated --script "resizepart $partQty 100%" ;
		fdisk -l $imageLocationInflated

		log "Resize the filesystem to fit the partition."
		loopId=$(kpartx -sav $imageLocationInflated | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)
		sleep 5
		ls -l /dev/mapper/

		e2fsck -f /dev/mapper/loop${loopId}p$partQty
		resize2fs /dev/mapper/loop${loopId}p$partQty
		kpartx -d $imageLocationInflated
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
