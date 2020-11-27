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
		loopId=$(kpartx -sav "$imageLocationInflated" | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)
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
	buildCmd=$3

	if [[ ! $(dpkg --print-architecture) == $cpuArch ]] || [[ $cpuArch == 'debian-live' ]]; then # if the target arch is not the same as the host arch use qemu.

	  if [[ $cpuArch == arm64 ]]; then
		  qemuArch=" -q qemu-aarch64"
	  elif [[ $cpuArch == armhf ]]; then
		  qemuArch=" -q qemu-arm"
	  fi
	  proot $qemuArch \
		--root-id \
		--rootfs=$workDir/rootfs \
		--cwd=/install-scripts \
		--mount=/etc/resolv.conf:/etc/resolv.conf \
		--mount=/dev:/dev \
		--mount=/sys:/sys \
		--mount=/proc:/proc \
		$buildCmd


	else # just chroot
		mount --bind /dev $workDir/rootfs/dev
		mount -t proc /proc $workDir/rootfs/proc
		mount --bind /sys $workDir/rootfs/sys
		mount --bind /tmp $workDir/rootfs/tmp
#
		cp /etc/resolv.conf  $workDir/rootfs/etc/
		chroot $workDir/rootfs /bin/bash <<EOT
cd /install-scripts ;
$buildCmd
EOT
		rm $workDir/rootfs/etc/resolv.conf
		umount $workDir/rootfs/dev
		umount $workDir/rootfs/proc
		umount $workDir/rootfs/sys
		umount $workDir/rootfs/tmp

	fi

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
