#!/bin/bash -xe
{
	source lib.sh
	checkRoot
	#################################################################################
	##
	##  SYNOPSIS
	##      build.sh
    ##
    ##  DESCRIPTION
	##      -o
	##         The base operating system to build on :
	##         Supported option are raspios|armbian-pine64so|debian-live|debian-vbox
	##
	##      -a
	##          The processor architecture to build on. If the architecture is not the same as the host qemu will be
	##          used. Otherwise only chroot will be used.
	##          Supported option are armhf|arm64|amd64
    ##
    ##      -v
    ##          The name to include in the output file name. If none is provided, a timestamp will be used.
	##
	##      -s
	##          A string of space separated stages to build. If nothing is provided, all stage will be build.
	##
	##  EXAMPLES:
	##      sudo ./build.sh -o raspios -a arm64
	##      sudo ./build.sh -o raspios -a arm64 -v 0.9.0 -s "0 2 4"
	##      sudo ./build.sh -o raspios -a arm64 -s "0 2.1 2.2 2.3 4 6.1 8"
	##      sudo ./build.sh -o raspios -a arm64 -h pi@192.168.1.123
	##
	##  To mount mount the image/iso and have a prompt inside the chroot: sudo ./build.sh raspios arm64 0.9.0 bash
	##
	#################################################################################



###########
### Preflight checks
###########

    ## Assign options
	while getopts ":o:a:v:s:" opt; do
	  case $opt in
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
	  esac
	done

	## Set default values if missing.
	baseOS="${baseOS:-raspios}"
	cpuArch="${cpuArch:-armhf}"
	lmVersion="${lmVersion:-$EPOCHSECONDS}"
	stagesToBuild="${stagesToBuild:-*}"
	buildCmd="./install.sh $stages"
	[[ $stages == 'bash' ]] && buildCmd='/bin/bash' ;

	## Validate arguments.
	supportedOS=(raspios debian-live pine64so)
	if ! (printf '%s\n' "${supportedOS[@]}" | grep -xq $baseOS); then
		echo "ERROR: Unsupported os." ; exit 1
	fi

	supportedArch=(armhf arm64 amd64)
	if ! (printf '%s\n' "${supportedArch[@]}" | grep -xq $cpuArch); then
		echo "ERROR: Unsupported cpu arch." ; exit 1
	fi

	## Setup the workspace
	setupWorkSpace "$baseOS-$cpuArch"
	cacheDir="./cache/$baseOS-$cpuArch"
	workDir="./work/$baseOS-$cpuArch"
	releaseDir="./release/"

	## Check if everything have been unmounted on the previous run.
	safetyChecks



###########
### Caching phase
###########

	## If the source OS is not found in cache, download it.
	if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
		if [[ "$baseOS" == "raspios" ]]; then
			zipName="raspios_lite_${cpuArch}_latest"
			wget -P "$cacheDir/" "https://downloads.raspberrypi.org/$zipName"
			7z e -o"$cacheDir/" "$cacheDir/$zipName"
			mv "$cacheDir"/????-??-??-"$baseOS"-buster-"$cpuArch"-lite.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" == "pine64so" ]]; then
			zipName="Armbian_21.02.3_Pine64so_buster_current_5.10.21.img.xz"
			wget -P "${cacheDir}/" "https://dl.armbian.com/pine64so/archive/$zipName"
			7z e -o"${cacheDir}/" "${cacheDir}/${zipName}"
			mv "$cacheDir"/Armbian_??.??.?_Pine64so_buster_current_?.??.??.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" =~ debian-* ]]; then
			wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-10.9.0-$cpuArch-standard+nonfree.iso"
			mv "$cacheDir/debian-live-10.9.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"
		fi
	fi



	## if it's an image file, we assume that it will need to be inflated.
	if [[ ! -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" && -f "$cacheDir/$baseOS-$cpuArch.base.img" ]]; then
		inflateImage "$baseOS" "$cacheDir/$baseOS-$cpuArch.base.img"
	fi



###########
### Build phase
###########
	# if it's an image file copy and mount it
	if [ -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" ]; then
	 	cp "$cacheDir/$baseOS-$cpuArch.base.img-inflated" "$workDir/$baseOS-$cpuArch.base.img" &

		mountSourceImage "$cacheDir/$baseOS-$cpuArch.base.img"

		mount -t overlay -o lowerdir=$workDir/originalRootfs,upperdir=$workDir/upperLayer,workdir=$workDir/workdir  none $workDir/fakeLayer
		if [ $partQty == 2 ]; then
			cp -ar $workDir/originalBootfs/boot/* $workDir/fakeLayer/boot
		fi

		addLysmarineScripts "$workDir/fakeLayer"
		chrootAndBuild

		wait


		mountReleaseImage "$workDir/$baseOS-$cpuArch.base.img"
		if [ $partQty == 2 ]; then
			cp -ar $workDir/fakeLayer/boot/* $workDir/releaseBootfs
			rm -r $workDir/fakeLayer/boot/*
		fi
		cp -ar $workDir/fakeLayer/* $workDir/releaseRootfs

		umount $workDir/fakeLayer || true
		umount $workDir/originalRootfs || true
		umount $workDir/originalBootfs || true
		umount $workDir/releaseBootfs || true
		umount $workDir/releaseRootfs || true

		mv "$workDir/$baseOS-$cpuArch.base.img" "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img"



	elif [[ "$baseOS" == 'debian-live' ]]; then # if it's an ISO file extract it and mount it
		if [[ ! -n "$(ls -A $cacheDir/isoContent/)" ]]; then
		 	7z x "$cacheDir/${baseOS}-${cpuArch}.base.iso" -o$cacheDir/isoContent
		fi
		if [[ ! -d "$cacheDir/squashfs-root" ]]; then
		    mount -t squashfs -o loop "$cacheDir/isoContent/live/filesystem.squashfs" $workDir/rootfs
			cp -a $workDir/rootfs "$cacheDir/squashfs-root"
			umount $workDir/rootfs
			rm -rf $cacheDir/isoContent/live/filesystem.squashfs
		fi

		safetyChecks

		# Build lysmarine
		#cp -rp "$cacheDir/squashfs-root/"* "$workDir/rootfs"

		mount -t overlay -o lowerdir=$cacheDir/squashfs-root,upperdir=$workDir/upperLayer,workdir=$workDir/workdir  none $workDir/fakeLayer

		ls -lah $workDir/fakeLayer
		touch $workDir/fakeLayer/sdfsdfdsf


		addLysmarineScripts "$workDir/fakeLayer"
		chrootAndBuild

		# Re-squash the file system.
		mkdir -p "$workDir/isoContent/live/"
		mksquashfs "$workDir/fakeLayer" "$workDir/isoContent/live/filesystem.squashfs" -comp xz -noappend

		umount $workDir/fakeLayer

		# Adapt the iso
		ls -lah "$workDir/isoContent/live/filesystem.squashfs"
		md5sum "$workDir/isoContent/live/filesystem.squashfs"
		rsync -Prq --exclude=*"/filesystem.squashfs" "$cacheDir"/isoContent/ "$workDir/isoContent"
		ls -lah "$workDir/isoContent/live/filesystem.squashfs"
		md5sum "$workDir/isoContent/live/filesystem.squashfs"

		rsync -hPr  "$cacheDir/isoContent/.disk" "$workDir/isoContent"
		cp files/preseed.cfg "$workDir/isoContent"
		cp files/splash.png "$workDir/isoContent/isolinux/"
		cp files/menu.cfg "$workDir/isoContent/isolinux/"
		cp files/stdmenu.cfg "$workDir/isoContent/isolinux/"

		# Create the iso
		xorriso -as mkisofs -V 'lysmarineOSlive-amd64' -o "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.iso" -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus "$workDir/isoContent"
		rm -r $workDir/isoContent

	else
		echo "Unknown base OS"
		exit 1
	fi

	exit 0
}
