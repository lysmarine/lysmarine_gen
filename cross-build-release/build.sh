#!/bin/bash -xe
{
	source lib.sh
	checkRoot



###########
### Preflight checks
###########

    ## Assign options
	while getopts ":b:a:v:s:r:h" opt; do
	  case $opt in
		b)
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
		 h)
		   showHelp
		 ;;
	  esac
	done

	## Set default values if missing.

	baseOS="${baseOS:-raspios}"
	cpuArch="${cpuArch:-armhf}"
	lmVersion="${lmVersion:-$EPOCHSECONDS}"
	#stages="${$stages:-$defaultStages}"
	[[  -z  $stages  ]] && 	stages='0 2 4 6 8'
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

	## Setup the workspaces
	setupWorkSpace "$baseOS-$cpuArch"
	cacheDir="./cache/$baseOS-$cpuArch"
	workDir="./work/$baseOS-$cpuArch"
	releaseDir="./release/"

	## Check if everything have been unmounted on the previous run.
	safetyChecks



###########
### Get the base OS
###########

	## If the source OS is not found in cache, download it.
	if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
		if [[ "$baseOS" == "raspios" ]]; then
			zipName="raspios_lite_${cpuArch}_latest"
			wget -P "$cacheDir/" "https://downloads.raspberrypi.org/$zipName"
			7z e -o"$cacheDir/" "$cacheDir/$zipName"
			mv "$cacheDir"/????-??-??-"$baseOS"-bullseye-"$cpuArch"-lite.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" == "pine64so" ]]; then
			zipName="Armbian_21.08.1_Pine64_bullseye_current_5.10.60.img.xz"
			wget -P "${cacheDir}/" "https://armbian.tnahosting.net/dl/pine64/archive/$zipName"
			7z e -o"${cacheDir}/" "${cacheDir}/${zipName}"
			mv "$cacheDir"/Armbian_??.??.?_Pine64_bullseye_current_?.??.??.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" =~ debian-* ]]; then
			wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-11.2.0-$cpuArch-standard+nonfree.iso"
			mv "$cacheDir/debian-live-11.2.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"

		fi
	fi


###########
### Extract the base OS
###########

	if [[ -z "$(ls -A $cacheDir/baseOS)" && -f "$cacheDir/$baseOS-$cpuArch.base.img" ]]; then
		inflateImage "$baseOS" "$cacheDir/$baseOS-$cpuArch.base.img"
		mountSourceImage "$cacheDir/$baseOS-$cpuArch.base.img"
		cp -R $workDir/mnt/. $cacheDir/baseOS
		umount $workDir/mnt/boot || true
		umount $workDir/mnt || true

	elif [[ -z "$(ls -A $cacheDir/baseOS)"  && -f "$cacheDir/$baseOS-$cpuArch.base.iso" ]]; then
	 	7z x "$cacheDir/${baseOS}-${cpuArch}.base.iso" -o$cacheDir/iso
	 	unsquashfs  -f -d $cacheDir/baseOS $cacheDir/iso/live/filesystem.squashfs

	fi

###########
### Build lysmarine
###########

	# start copying the baseOs from cache to workspace in the background to save time.
	cp $cacheDir/${baseOS}-${cpuArch}.base.img-inflated $workDir/ &
	cp -r $cacheDir/iso/. $workDir/iso &

	# delete requested build layers from cache.
	set -f
	log "Deleting cached layers"
	for layer in $remove; do
		rm -r "./$cacheDir/$layer" || true
	done

# Overlay the work area over the exposed baseOS in the cache to start building right away
	cachedLayers="";
	for argument in $stages; do # Loop each requested stages to build
		if [ -d ./$cacheDir/$argument ] ; then # if the stage is already available in the cache, use it instead of building it,
				cachedLayers=":$cachedLayers"
			cachedLayers="$cacheDir/$argument$cachedLayers"

		else # mount and build
			stage=$(echo $argument | cut -d '.' -f 1)
			script=$(echo $argument | cut -s -d '.' -f 2)
			if [ ! $script ]; then script="*" ; fi
			rm -r "./$workDir/$argument" || true
			mkdir $workDir/$argument
			mount -t overlay -o lowerdir=$cachedLayers$cacheDir/baseOS,upperdir=$workDir/$argument,workdir=$workDir/workdir none $workDir/fakeLayer

			addLysmarineScripts "$workDir/fakeLayer"
			buildCmd="./install.sh $stage.$script"
    		chrootAndBuild

			umount $workDir/fakeLayer || true
			cp -r $workDir/$argument  $cacheDir/$argument
			[ -f cachedLayers ] && cachedLayers=":"
			cachedLayers="$cacheDir/$argument:$cachedLayers"
		fi
		set +f
	done


###########
### Repackage the OS for shipping
###########
	mount -t overlay overlay -o lowerdir=$cachedLayers$cacheDir/baseOS,upperdir=$workDir/oldstage,workdir=$workDir/workdir $workDir/fakeLayer

	# Merging build layers in the BaseOs that will be shipped.
	if [ -f "$cacheDir/$baseOS-$cpuArch.base.iso" ]; then

		mkdir -p "$workDir/iso/live/"
		mksquashfs "$workDir/fakeLayer" "$workDir/iso/live/filesystem.squashfs" -comp xz -noappend
		md5sum "$workDir/iso/live/filesystem.squashfs"
		rsync -hPr  "$cacheDir/iso/.disk" "$workDir/iso"

		cp files/preseed.cfg "$workDir/iso"
		cp files/splash.png "$workDir/iso/isolinux/"
		cp files/menu.cfg "$workDir/iso/isolinux/"
		cp files/stdmenu.cfg "$workDir/iso/isolinux/"
		wait

		xorriso -as mkisofs -V 'lysmarineOSlive-amd64' -o "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.iso" -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus "$workDir/iso"

	elif [ -f "$cacheDir/$baseOS-$cpuArch.base.img" ]; then
		wait
	 	mountSourceImage "$workDir/$baseOS-$cpuArch.base.img-inflated"
	 	cp -ar $workDir/fakeLayer/* $workDir/mnt

		shrinkWithPishrink $cacheDir $workDir/$baseOS-$cpuArch.base.img-inflated
		mv "$workDir/$baseOS-$cpuArch.base.img-inflated" "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img"
	fi



###########
### Cleanup workspace
###########

	umount $workDir/fakeLayer || true
	umount $workDir/mnt/boot || true
	umount $workDir/mnt || true
	rm -r $workDir/iso || true
exit 0
}
