#!/usr/bin/env bash
# shellcheck disable=SC2115

log() {
	echo -e "\e[32m[$(date +'%T')] \e[1m $1 \e[0m"
}



logErr() {
	echo -e "\e[91m [$(date +'%T')] ---> $1 \e[0m"
}



showHelp() {
 echo -e '
SYNOPSIS
    build.sh

  DESCRIPTION
    -b, -o
         The base operating system to build on :
         Supported option are raspios|armbian-pine64so|debian-live

    -a
        The processor architecture to build on. If the architecture is not the same as the host qemu will be
        used. Otherwise only chroot will be used.
        Supported option are armhf|arm64|amd64

    -v
        The name to include in the output file name. If none is provided, a timestamp will be used.

    -s
        A string of space separated stages to build. If nothing is provided, all stage will be build.

    -r
        A string of space separated stages to remove from cache. If nothing is provided, no stages will be removed.

    -d
        Build a virtualbox image for development and testing purpose.

    -h
        Show help message.



EXAMPLES:
sudo ./build.sh -o raspios -a arm64
sudo ./build.sh -o raspios -a arm64 -v Latest -s "0 2 4"
sudo ./build.sh -o raspios -a arm64 -s "0 2.1 2.2 2.3 4 6.1 8"
sudo ./build.sh -b raspios -a armhf -s "0 2 6 8" -r "0 2 4 6 8"

Copyright 2023, Frederic Guilbault, GPLv3
'
exit 0 ;
}



setArguments() {
  echo "";
	while getopts ":b:o:a:v:s:r:hd" opt; do
	  case $opt in
		b)
		  baseOS="$OPTARG"
		  ;;
		o)
  	  baseOS="$OPTARG"
		  ;;
		 a)
		  cpuArch=$OPTARG
		  ;;
		 v)
		  lmVersion=$OPTARG
		  ;;
		 s)
		  stages=$OPTARG
		  ;;
		 r)
		  remove="$OPTARG"
		  ;;
		 d)
		  baseOS="vagrant-debian"
      cpuArch="amd64"
		  ;;
		 h)
		  showHelp
		 ;;
	   *)
	    showHelp
     ;;
	  esac
	done

	## Set default values if missing.
	baseOS="${baseOS:-raspios}"
	cpuArch="${cpuArch:-armhf}"
	lmVersion="${lmVersion:-$EPOCHSECONDS}"
  supportedOS=(raspios debian-live vagrant-debian pine64so)
  supportedArch=(armhf arm64 amd64)

  ## Validate arguments.
  if ! (printf '%s\n' "${supportedOS[@]}" | grep -xq "$baseOS"); then
    logErr "ERROR: Unsupported os." ; exit 1
  fi


  if ! (printf '%s\n' "${supportedArch[@]}" | grep -xq "$cpuArch"); then
    logErr "ERROR: Unsupported cpu arch." ; exit 1
  fi
}


# Create caching folder hierarchy to work with this architecture
setupWorkSpace() {
  ## Folder containing the unziped original content of the isofile
	mkdir -p "$cacheDir/iso"
	## Content of the root filesystem extracted from isofile ( unused if it's an imagefile)
	mkdir -p "$cacheDir/mnt"
	## mountPoint of the root fileSystem of the original OS to be served as lower layer in overlayfs
	mkdir -p "$workDir/mnt"
	## mountPoint of the root fileSystem of the release OS to put the payload in it
	mkdir -p "$workDir/releaseMnt"
  # OverlayFS merged and work layers
	mkdir -p "$workDir/workdir"
	mkdir -p "$workDir/fakeLayer"
	# Where the final lysmarine OS is stored.
	mkdir -p "$releaseDir"
	# mergerFS location for where overlayfs need can't see mounts.
	mkdir -p "$workDir/mergedMnt"
}


## Get the requested stage list and populate split it apart to separate each script.
populateStageList() {
  [[ -z  "$stages" ]] && stages='0 2 4 6 8'
 	newlist=' '
	for stage in $stages ; do
	   script=$(echo "$stage" | cut -s -d '.' -f 2)
	   if [ ! "$script" ]; then # list all scripts
		   for scriptpath in $(find ../install-scripts/$stage-*/ -maxdepth 1 -type f) ;do
			   scriptNumber=$(basename "$scriptpath" | cut -s -d '-' -f 1)
			   newlist+="$stage.$scriptNumber "
		   done
	   else
		   newlist+="$stage "
	   fi
	done
	stages=$(echo "$newlist" | xargs -n1 | sort -V | xargs)
  echo "Stages to build : $stages"
}



populateRemoveList() {
 	newlist=' '
	for stage in $remove ; do
	   script=$(echo "$stage" | cut -s -d '.' -f 2)
	   if [ ! "$script" ]; then # list all scripts
		   for scriptpath in $(find ../install-scripts/$stage-*/ -maxdepth 1 -type f) ;do
			   scriptNumber=$(basename "$scriptpath" | cut -s -d '-' -f 1)
			   newlist+="$stage.$scriptNumber "
		   done
	   else
		   newlist+="$stage "
	   fi
	done
	remove=$(echo "$newlist" | xargs -n1 | sort -V | xargs)
  echo "Stages to remove : $remove"

}

# Check if the user run with root privileges
checkRoot() {
	if [ $EUID -ne 0 ]; then
		echo "This tool must be run as root."
		exit 1
	fi
}



mountSourceImage() {
	imageFile=$1
	mountPoint=$2

  log " Mounting $imageFile"
	# Mount the image and make the binds required to chroot.
	partitions=$( kpartx -sav "$imageFile" | cut -d' ' -f3 )
	partQty=$( echo "$partitions" | wc -w )
	loopId=$( echo "$partitions" | grep -oh '[0-9]*' | head -n 1 )

	if [ "$partQty" == 4 ]; then
		mount -v "/dev/mapper/loop${loopId}p2" "$mountPoint"
		mount -v "/dev/mapper/loop${loopId}p1" "$mountPoint/boot/firmware"
	elif [ "$partQty" == 3 ]; then
		mount -v "/dev/mapper/loop${loopId}p2" "$mountPoint"
		mount -v "/dev/mapper/loop${loopId}p1" "$mountPoint/boot/firmware"

	elif [ "$partQty" == 2 ]; then
		mount -v "/dev/mapper/loop${loopId}p2" "$mountPoint"
		mount -v "/dev/mapper/loop${loopId}p1" "$mountPoint/boot/firmware"

	elif [ "$partQty" == 1 ]; then
		mount -v "/dev/mapper/loop${loopId}p1" "$mountPoint"

	else
		logErr "Unsupported amount of partitions."; exit 1
	fi
}


inflateImage() {
	imageLocation=$1
  	size=$2
		log "Inflating OS image to have enough space to build lysmarine. "
		cp -fv "$imageLocation" "${imageLocation}-inflated"

		log "truncate image to 8G"
		truncate -s "$size" "${imageLocation}-inflated"

		log "resize last partition to 90%"
		partQty=$(fdisk -l "${imageLocation}-inflated" | grep -o "^${imageLocation}-inflated" | wc -l)
		parted "${imageLocation}-inflated" --script "resizepart $partQty 7G"
		fdisk -l "${imageLocation}-inflated"
  	log "Resize the filesystem to fit the partition."
		loopId=$(kpartx -sav "${imageLocation}-inflated" | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)

		e2fsck -af "/dev/mapper/loop${loopId}p${partQty}"
		resize2fs "/dev/mapper/loop${loopId}p${partQty}"
		kpartx -d "${imageLocation}-inflated"

    log "Add swap partition."

    parted "${imageLocation}-inflated" --script "mkpart primary linux-swap 7G -100m"
    newPartitionNumber=$(sfdisk -q -l "${imageLocation}-inflated" |tail -n1 | cut -f1 -d" " | grep -oh "[0-9]*$")
    loopId=$(kpartx -sav "${imageLocation}-inflated" | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)

     mkswap "/dev/mapper/loop${loopId}p${newPartitionNumber}"
    kpartx -d "${imageLocation}-inflated"
    log "Add New user overlay partition."
    parted "${imageLocation}-inflated" --script "mkpart primary ext4 -100m -1s"
    parted "${imageLocation}-inflated" --script "print"
    newPartitionNumber=$(sfdisk -q -l "${imageLocation}-inflated" |tail -n1 | cut -f1 -d" " | grep -oh "[0-9]*$")
    loopId=$(kpartx -sav "${imageLocation}-inflated" | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)
    mkfs.ext4 "/dev/mapper/loop${loopId}p${newPartitionNumber}"
    parted "${imageLocation}-inflated" --script "print"
    e2label "/dev/mapper/loop${loopId}p${newPartitionNumber}" useroverlay
    tune2fs -L useroverlay "/dev/mapper/loop${loopId}p${newPartitionNumber}"
    parted "${imageLocation}-inflated" --script "print"
    kpartx -d "${imageLocation}-inflated"
}



function addLysmarineScripts {
	rootfs=$1
	log "copying lysmarine on the image"
	cp -r "../install-scripts" "$rootfs/"
	chmod 0775 "$rootfs/install-scripts/install.sh"
}



function chrootAndBuild {

	# if the CPU arch is not the same on host then target, use qemu.
	if [[ ! $(dpkg --print-architecture) == "$cpuArch" ]] ; then

	  if [[ $cpuArch == "arm64" ]]; then
		  qemuArch="qemu-aarch64-static"
	  elif [[ $cpuArch == armhf ]]; then
		  qemuArch="qemu-arm-static"
	  fi
	
		mount -o bind /dev $workDir/fakeLayer/dev
		mount -t proc none $workDir/fakeLayer/proc
		mount -t sysfs /sys $workDir/fakeLayer/sys
		mount -o bind /etc/resolv.conf $workDir/fakeLayer/etc/resolv.conf
		mount --bind /dev/pts $workDir/fakeLayer/dev/pts
		addLysmarineScripts "$workDir/fakeLayer"

		cp /usr/bin/$qemuArch $workDir/fakeLayer/usr/bin
		echo  "cd /install-scripts ;uname -a ; $qemuArch /usr/bin/uname -a ; $qemuArch /usr/bin/pwd; $qemuArch /bin/bash ./${buildCmd}" > $workDir/fakeLayer/run.sh
		chmod a+x $workDir/fakeLayer/run.sh
		chroot $workDir/fakeLayer/ /run.sh

		umount $workDir/fakeLayer/dev/pts
		umount $workDir/fakeLayer/dev
		umount $workDir/fakeLayer/proc
		umount $workDir/fakeLayer/sys
	    umount $workDir/fakeLayer/etc/resolv.conf
		rm $workDir/fakeLayer/usr/bin/$qemuArch

	  return=$?
	  [ $return -ne 0 ] && exit 1


	else # just chroot
	  mount --bind /dev "$workDir/fakeLayer/dev"
	  mount -t proc /proc "$workDir/fakeLayer/proc"
	  mount --bind /sys "$workDir/fakeLayer/sys"
	  mount --bind /tmp "$workDir/fakeLayer/tmp"
	  cp /etc/resolv.conf  "$workDir/fakeLayer/etc/"
	  chroot "$workDir/fakeLayer" /bin/bash <<EOT
cd /install-scripts ;
$buildCmd
EOT

	 return=$?
	 rm "$workDir/fakeLayer/etc/resolv.conf"
	 umount "$workDir/fakeLayer/dev" || true
	 umount "$workDir/fakeLayer/proc"
	 umount "$workDir/fakeLayer/sys"
	 umount "$workDir/fakeLayer/tmp"
	 [ $return -ne 0 ] && exit 1
  fi
}



function shrinkWithPishrink {
	cacheDir=$1
	imgLocation=$2

	if [ ! -f "$cacheDir/pishrink.sh" ]; then
		wget "https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh" -P "$cacheDir/"
		chmod +x "$cacheDir/pishrink.sh"
	fi

	"$cacheDir"/pishrink.sh "$imgLocation"

}



function safetyChecks {
     ## Make sure we have a clean workspace.

	if [ "$(ls -A "$workDir/fakeLayer/boot" 2> /dev/null)" ] ; then
		logErr "${workDir}/fakeLayer/boot is not empty. Previous run have fail ?"
		umount "$workDir/fakeLayer/boot"  || umount -l "$workDir/fakeLayer/boot" || /bin/true
	fi

	if [ "$(ls -A "$workDir/fakeLayer/" 2> /dev/null)" ] ; then
		logErr "$workDir/fakeLayer is not empty. Previous run have fail ?"
		umount "$workDir/fakeLayer"  || umount -l "$workDir/fakeLayer" || /bin/true
		rm -r "$workDir/fakeLayer/*"
	fi

	if [ "$(ls -A "$workDir/mnt/boot" 2> /dev/null)" ] ; then
		logErr "${workDir}/mnt/boot is not empty. Previous run have fail ?"
		umount "$workDir/mnt/boot"  || umount -l "$workDir/mnt/boot" || /bin/true
	fi

	if [ "$(ls -A "$workDir/mnt" 2> /dev/null)" ] ; then
		logErr "${workDir}/mnt is not empty. Previous run have fail ?"
		umount "$workDir/mnt"  || umount -l "$workDir/mnt" || /bin/true
		rm -r "$workDir/mnt/*"
	fi
	if [ "$(ls -A "$workDir/mergedMnt" 2> /dev/null)" ] ; then
		logErr "${workDir}/mergedMnt is not empty. Previous run have fail ?"
		umount "$workDir/mergedMnt"  || umount -l "$workDir/mergedMnt" || /bin/true
		rm -r "$workDir/mergedMnt/*"
	fi

}
