#!/usr/bin/env bash
log() {
	echo -e "\e[32m[$(date +'%T')] \e[1m $1 \e[0m"
}

logErr() {
	echo -e "\e[91m [$(date +'%T')] ---> $1 \e[0m"
}

function showHelp() {
 echo '
 	  SYNOPSIS
 	      build.sh

      DESCRIPTION
 	      -b
 	         The base operating system to build on :
 	         Supported option are raspios|armbian-pine64so|debian-live|debian-vbox

 	      -a
 	          The processor architecture to build on. If the architecture is not the same as the host qemu will be
 	          used. Otherwise only chroot will be used.
 	          Supported option are armhf|arm64|amd64
          -v
              The name to include in the output file name. If none is provided, a timestamp will be used.

 	      -s
 	          A string of space separated stages to build. If nothing is provided, all stage will be build.

	EXAMPLES:
		sudo ./build.sh -o raspios -a arm64
		sudo ./build.sh -o raspios -a arm64 -v 0.9.0 -s "0 2 4"
		sudo ./build.sh -o raspios -a arm64 -s "0 2.1 2.2 2.3 4 6.1 8"

'
}

# Create caching folder hierarchy to work with this architecture
setupWorkSpace() {
	thisArch=$1

	mkdir -p ./cache/${thisArch}/iso
	mkdir -p ./cache/${thisArch}/mnt
	mkdir -p ./cache/${thisArch}/baseOS

	mkdir -p ./work/${thisArch}/mnt
	mkdir -p ./work/${thisArch}/workdir
	mkdir -p ./work/${thisArch}/oldstage
	mkdir -p ./work/${thisArch}/newstage
	mkdir -p ./work/${thisArch}/fakeLayer || true

	mkdir -p ./release/
}

# Check if the user run with root privileges
checkRoot() {
	if [ $EUID -ne 0 ]; then
		echo "This tool must be run as root."
		exit 1
	fi
}


mountReleaseImage() {
	log "Mounting release image File"
	imageFile=$1

	# Mount the image and make the binds required to chroot.
	partitions=$(kpartx -sav $imageFile | cut -d' ' -f3)
	partQty=$(echo $partitions | wc -w)
	echo $partQty partitions detected.

	## Mount partition table in /dev/loop
	loopId=$(kpartx -sav $imageFile | cut -d' ' -f3 | grep -oh '[0-9]*' | head -n 1)

 	## Mount actual partitions
	if [ $partQty == 2 ]; then
		mount -v /dev/mapper/loop${loopId}p2 ./$workDir/releaseRootfs/
		mount -v /dev/mapper/loop${loopId}p1 ./$workDir/releaseBootfs/

	elif [ $partQty == 1 ]; then
		mount -v /dev/mapper/loop${loopId}p1 ./$workDir/originalRootfs/
		mount --bind ./$workDir/originalRootfs/boot ./$workDir/originalBootfs/
	else
		log "ERROR: unsuported amount of partitions."; exit 1
	fi
}

mountSourceImage() {
	log "Mounting Original Image File"
	imageFile=$1

	# Mount the image and make the binds required to chroot.
	partitions=$(kpartx -sav $imageFile | cut -d' ' -f3)
	partQty=$(echo $partitions | wc -w)
	echo $partQty partitions detected.

	## Mount partition table in /dev/loop
	loopId=$(kpartx -sav $imageFile | cut -d' ' -f3 | grep -oh '[0-9]*' | head -n 1)

 	## Mount actual partitions
	if [ $partQty == 2 ]; then
		mount -v /dev/mapper/loop${loopId}p2 ./$workDir/mnt/
		mount -v /dev/mapper/loop${loopId}p1 ./$workDir/mnt/boot

	elif [ $partQty == 1 ]; then
		mount -v /dev/mapper/loop${loopId}p1 ./$workDir/mnt/

	else
		log "ERROR: unsupported amount of partitions."; exit 1
	fi
}



mountImageFile() {  # deprecated
	workDir=$1
	imageFile=$2
	rootfs=$workDir/rootfs

	log "Mounting Image File"
	if [ -n "$(ls -A $rootfs)" ]; then
		logErr "$rootfs is not empty. Previous failure to unmount?"
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

		e2fsck -af "/dev/mapper/loop${loopId}p${partQty}"
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

	if [[ ! $(dpkg --print-architecture) == $cpuArch ]] ; then # if the target arch is not the same as the host arch use qemu.

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

function chrootAndBuild {

	# if the CPU arch is not the same on host then target, use qemu.
	if [[ ! $(dpkg --print-architecture) == $cpuArch ]] ; then

	  if [[ $cpuArch == arm64 ]]; then
		  qemuArch=" -q qemu-aarch64"
	  elif [[ $cpuArch == armhf ]]; then
		  qemuArch=" -q qemu-arm"
	  fi

	  proot $qemuArch \
		--root-id \
		--rootfs=$workDir/fakeLayer \
		--cwd=/install-scripts \
		--mount=/etc/resolv.conf:/etc/resolv.conf \
		--mount=/dev:/dev \
		--mount=/sys:/sys \
		--mount=/proc:/proc \
		$buildCmd

	else # just chroot

	  mount --bind /dev $workDir/fakeLayer/dev
	  mount -t proc /proc $workDir/fakeLayer/proc
	  mount --bind /sys $workDir/fakeLayer/sys
	  mount --bind /tmp $workDir/fakeLayer/tmp
	  cp /etc/resolv.conf  $workDir/fakeLayer/etc/
	  chroot $workDir/fakeLayer /bin/bash <<EOT
cd /install-scripts ;
$buildCmd
EOT

	 rm $workDir/fakeLayer/etc/resolv.conf
	 umount $workDir/fakeLayer/dev
	 umount $workDir/fakeLayer/proc
	 umount $workDir/fakeLayer/sys
	 umount $workDir/fakeLayer/tmp
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



function safetyChecks {
     ## Make sure we have a clean workspace.

	if [ "$(ls -A $workDir/fakeLayer/boot)" ] ; then
		   logErr "$workDir/fakeLayer/boot is not empty. Previous run have fail ?"
		   umount $workDir/fakeLayer/boot  || umount -l $workDir/fakeLayer/boot || /bin/true
	fi

	if [ "$(ls -A $workDir/fakeLayer/)" ] ; then
		   logErr "$workDir/fakeLayer is not empty. Previous run have fail ?"
		   umount $workDir/fakeLayer  || umount -l $workDir/fakeLayer || /bin/true
		   rm -r $workDir/fakeLayer/*
		   exit 1
	fi

	if [ "$(ls -A $workDir/originalRootfs/)" ] ; then
		   logErr "$workDir/originalRootfs is not empty. Previous run have fail ?"
		   umount $workDir/originalRootfs  || umount -l $workDir/originalRootfs || /bin/true
		   exit 1
	fi
	if [ "$(ls -A $workDir/originalBootfs/boot)" ] ; then
		   logErr "$workDir/originalBootfs is not empty. Previous run have fail ?"
		   umount $workDir/originalBootfs/boot  || umount -l $workDir/originalBootfs/boot || /bin/true
		   exit 1
	fi
	if [ "$(ls -A $workDir/releaseRootfs/)" ] ; then
		   logErr "$workDir/releaseRootfs is not empty. Previous run have fail ?"
		   umount $workDir/releaseRootfs  || umount -l $workDir/releaseRootfs || /bin/true
		   umount $workDir/releaseBootfs  || umount -l $workDir/releaseBootfs || /bin/true
		   exit 1
	fi
	if [ "$(ls -A $workDir/upperLayer/)" ] ; then
		   logErr "$workDir/upperLayer is not empty. Previous run have fail ?"
		  rm -rf $workDir/upperLayer/*
		  rm -rf $workDir/upperLayer/.*
		   exit 1
	fi

}