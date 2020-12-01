#!/bin/bash -xe
{
	source lib.sh
	checkRoot
	#################################################################################
	##
	##  Usage: build.sh baseOS processorArchitecture lmVersion stagesToBuild
    ##
	##  Note : baseOs options are raspios|armbian-pine64so|debian-live|debian-vbox
	##  Note : processorArchitecture are armhf|arm64|amd64
    ##
	##  Example: sudo ./build.sh raspios arm64 0.9.0 "0 2 4 6 8"
	##  To mount mount the image/iso and have a prompt inside the chroot: sudo ./build.sh raspios arm64 0.9.0 bash
	##
	#################################################################################

	baseOS="${1:-raspios}"
	cpuArch="${2:-armhf}"
	lmVersion="${3:-nightBuild_$EPOCHSECONDS}"
	stagesToBuild="$4"
	buildCmd="./install.sh $4"
	[[ $4 == 'bash' ]] && buildCmd='/bin/bash' ;

	# Setup the workspace
	setupWorkSpace "$baseOS-$cpuArch"
	cacheDir="./cache/$baseOS-$cpuArch"
	workDir="./work/$baseOS-$cpuArch"
	releaseDir="./release/"



	# if the source OS is not found in cache, download it.
	if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
		if [[ "$baseOS" == "raspios" ]]; then
			zipName="raspios_lite_${cpuArch}_latest"
			wget -P "$cacheDir/" "https://downloads.raspberrypi.org/$zipName"
			7z e -o"$cacheDir/" "$cacheDir/$zipName"
			mv "$cacheDir"/????-??-??-"$baseOS"-buster-"$cpuArch"-lite.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" == "armbian-pine64so" ]]; then

			zipName="Armbian_20.11_Pine64_buster_current_5.8.16.img.xz"
			wget -P "${cacheDir}/" "https://dl.armbian.com/pine64so/archive/$zipName"
			7z e -o"${cacheDir}/" "${cacheDir}/${zipName}"
			mv "$cacheDir"/Armbian_??.??_Pine64so_buster_current_?.?.??.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" =~ debian-* ]]; then
			wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-10.6.0-$cpuArch-standard+nonfree.iso"
			mv "$cacheDir/debian-live-10.6.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"

		else
			echo "Unknown baseOS"; exit 1
		fi
	fi



	# if it's an image file, we assume that it will need to be inflated.
	if [[ ! -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" && -f "$cacheDir/$baseOS-$cpuArch.base.img" ]]; then
		inflateImage "$baseOS" "$cacheDir/$baseOS-$cpuArch.base.img"
	fi



	# if it's an image file copy and mount it
	if [ -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" ]; then
		rsync -hPr "$cacheDir/$baseOS-$cpuArch.base.img-inflated" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		mountImageFile "$workDir" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		addLysmarineScripts "$workDir/rootfs"
		chrootWithProot "$workDir" "$cpuArch" "$buildCmd"
		umountImageFile "$workDir" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		shrinkWithPishrink "$cacheDir" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		rsync -hPr "$workDir/$baseOS-$cpuArch.base.img-inflated" "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img"



	elif [[ "$baseOS" == 'debian-live' ]]; then # if it's an ISO file extract it and mount it
		if [[ ! -n "$(ls -A $cacheDir/isoContent/)" ]]; then
		 	7z x "$cacheDir/${baseOS}-${cpuArch}.base.iso" -o$cacheDir/isoContent
		fi
		if [[ ! -d "$cacheDir/squashfs-root" ]]; then
			unsquashfs -d $cacheDir/squashfs-root "$cacheDir/isoContent/live/filesystem.squashfs"
			rm "$cacheDir/isoContent/live/filesystem.squashfs"
		fi

		# Safety check,
		if [ "$(ls -A $workDir/rootfs/)" ] ; then
		   logErr "$workDir/rootfs is not empty. Previous run have fail ?"
		   umount $workDir/rootfs/dev  || umount -l $workDir/rootfs/dev || /bin/true
		   umount $workDir/rootfs/proc || umount -l $workDir/rootfs/proc || /bin/true
		   umount $workDir/rootfs/sys  || umount -l $$workDir/rootfs/sys || /bin/true
		   umount $workDir/rootfs/tmp  || umount -l $$workDir/rootfs/tmp || /bin/true
		   umount $workDir/rootfs/tmp  || umount -l $$workDir/rootfs/tmp || /bin/true
		   rm -r $workDir/rootfs/*
		   exit 1
		fi

		# Build lysmarine
		cp -r "$cacheDir/squashfs-root/"* "$workDir/rootfs"
		addLysmarineScripts "$workDir/rootfs"
		chrootWithProot "$workDir" "$cpuArch" "$buildCmd"

		# Re-squash the file system.
		mkdir -p "$workDir/isoContent/live/"
		mksquashfs "$workDir/rootfs" "$workDir/isoContent/live/filesystem.squashfs" -comp xz -noappend -no-progress -info
		rm -r "$workDir"/rootfs/*

		# Adapt the iso
		rsync -hPr  "$cacheDir"/isoContent/* "$workDir/isoContent"
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
