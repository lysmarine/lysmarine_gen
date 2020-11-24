#!/usr/bin/env bash
log() {
	echo -e "\e[32m[$(date +'%T')] \e[1m $1 \e[0m"
}

logErr() {
	echo -e "\e[91m [$(date +'%T')] ---> $1 \e[0m"
}

# Create caching folder hierarchy to work with this architecture
setupWorkSpace() {
	thisArch=$1
	mkdir -p ./cache/${thisArch}/stageCache
	mkdir -p ./work/${thisArch}/rootfs
	mkdir -p ./work/${thisArch}/bootfs
	mkdir -p ./work/${thisArch}/isomount
	mkdir -p ./release/

}

# Check if the user run with root privileges
checkRoot() {
	if [ $EUID -ne 0 ]; then
		echo "This tool must be run as root."
		exit 1
	fi
}

mountImageFile() {
	workDir=$1
	imageFile=$2
	rootfs=$workDir/rootfs

	log "Mounting Image File"

	## Make sure it's not already mounted
	if [ -n "$(ls -A $rootfs)" ]; then
		logErr "$rootfs is not empty. Previous failure to unmount?"
		umountImageFile $1 $2
		exit
	fi

	# Mount the image and make the binds required to chroot.
	partitions=$(kpartx -sav $imageFile | cut -d' ' -f3)
	partQty=$(echo $partitions | wc -w)
	echo $partQty partitions detected.

	# mount partition table in /dev/loop
	loopId=$(kpartx -sav $imageFile | cut -d' ' -f3 | grep -oh '[0-9]*' | head -n 1)

	if [ $partQty == 2 ]; then
		mount -v /dev/mapper/loop${loopId}p2 $rootfs/
		if [ ! -d $rootfs/boot ]; then mkdir $rootfs/boot; fi
		mount -v /dev/mapper/loop${loopId}p1 $rootfs/boot/
	elif [ $partQty == 1 ]; then
		mount -v /dev/mapper/loop${loopId}p1 $rootfs/
	else
		log "ERROR: unsuported amount of partitions."
		exit 1
	fi
}

umountImageFile() {
	log "un-Mounting"
	workDir=$1
	imageFile=$2
	rootfs=$workDir/rootfs

	rm -rf $rootfs/home/border
	rm -rf $rootfs/install-scripts/stageCache/*
	rm -rf $rootfs/install-scripts/logs/*
	rm -rf $rootfs/var/log/*
	rm -rf $rootfs/tmp/*

	umount $workDir/rootfs/boot || /bin/true
	umount $workDir/rootfs || /bin/true
	kpartx -d $imageFile || /bin/true
}

inflateImage() {
	thisArch=$1
	imageLocation=$2
	imageLocationInflated=${imageLocation}-inflated

	if [ ! -f $imageLocationInflated ]; then
		log "Inflating OS image to have enough space to build lysmarine. "
		cp -fv ${imageLocation} $imageLocationInflated

		log "truncate image to 8G"
		truncate -s "8G" $imageLocationInflated

		log "resize last partition to 100%"
		partQty=$(fdisk -l $imageLocationInflated | grep -o "^$imageLocationInflated" | wc -l)
		parted $imageLocationInflated --script "resizepart $partQty 100%"
		fdisk -l $imageLocationInflated

		log "Resize the filesystem to fit the partition."
		echo "$imageLocationInflated"
		fdisk -l $imageLocationInflated
		kpartx -l "$imageLocationInflated"
		#kpartx -sav "$imageLocationInflated"
		loopId=$(kpartx -sav "$imageLocationInflated" | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)
		echo loopId
		sleep 3

		e2fsck -f "/dev/mapper/loop${loopId}p${partQty}"
		resize2fs "/dev/mapper/loop${loopId}p${partQty}"
		kpartx -d "$imageLocationInflated"
	else
		log "Using Ready to build image from cache"
	fi
}

function addLysmarineScripts {
	rootfs=$1
	log "copying lysmarine on the image"
	cp -r "../install-scripts" "$rootfs/"
	chmod 0775 "$rootfs/install-scripts/install.sh"
}

function chrootWithProot {
	workDir=$1
	cpuArch=$2
	stagesToBuild=$3
	if [[ $stagesToBuild == 'bash' ]]; then
		buildCmd='/bin/bash'
	else
		buildCmd="./install.sh $stagesToBuild"
	fi

	if [[ $cpuArch == arm64 ]]; then
		qemuArch="qemu-aarch64"
	elif [[ $cpuArch == armhf ]]; then
		qemuArch="qemu-arm"
	fi

	proot -q "$qemuArch" \
		--root-id \
		--rootfs=$workDir/rootfs \
		--cwd=/install-scripts \
		--mount=/etc/resolv.conf:/etc/resolv.conf \
		--mount=/dev:/dev \
		--mount=/sys:/sys \
		--mount=/proc:/proc \
		--mount=/tmp:/tmp \
		$buildCmd
}

function shrinkWithPishrink {
	cacheDir=$1
	imgLocation=$2

	if [ ! -f $cacheDir/pishrink.sh ]; then
		wget "https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh" -P "$cacheDir/"
		chmod +x "$cacheDir/pishrink.sh"
	fi

	"$cacheDir"/pishrink.sh "$imgLocation"

}

mountIsoFile() {
	workDir=$1
	isoFile=$2
	rootfs="$workDir/rootfs"

	log "Mounting Iso File"

	## Make sure it's not already mounted
	if [ -n "$(ls -A $rootfs)" ]; then
		logErr "$rootfs is not empty. Previous failure to unmount?"
		rm -r "$workDir"/rootfs/* || /bin/true
		rm -r "$workDir/rootfs/.disk" || /bin/true
		exit
	fi

	if [ -n "$(ls -A $workDir/squashfs-root)" ]; then
		logErr "$rootfs/squashfs-root is not empty. Previous failure to unmount?"
		umountIsoFile "$1" "$2"
		rm -r "$workDir/squashfs-root"
		exit
	fi

	# Copy file out of the iso image
	mount -o loop "$isoFile" "$workDir/isomount"
	cp -a "$workDir"/isomount/* "$workDir/rootfs"
	cp -a "$workDir/isomount/.disk" "$workDir/rootfs"
	cp "$workDir/isomount/live/filesystem.squashfs" "$workDir/"
	umount "$workDir/isomount"

	# unsquash the file system
	pushd "$workDir/" || exit
	unsquashfs "./filesystem.squashfs"
	popd || exit

}

umountIsoFile() {
	log "un-Mounting"
	workDir=$1
	umount -l "$workDir/squashfs-root/dev" || /bin/true
	umount "$workDir/squashfs-root/proc" || /bin/true
	umount -l "$workDir/squashfs-root/sys" || /bin/true
	umount "$workDir/squashfs-root/tmp" || /bin/true
	umount "$workDir/squashfs-root/etc/resolv.conf" || /bin/true
	umount "$workDir/isomount" || /bin/true

}
