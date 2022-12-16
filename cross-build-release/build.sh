#!/bin/bash
source lib.sh

  	###########
	### Preflight checks
	###########
	checkRoot

    ## Assign options
	while getopts ":b:a:v:s:r:h:d" opt; do
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
		 d)
		  vbox=1
		  baseOS="debian-vbox"
		  cpuArch="amd64"
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

	## Define the stage list requested.
	[[  -z  $stages  ]] && 	stages='0 2 4 6 8'
	populateStageList
	buildCmd="./install.sh $stages"
	[[ $stages == 'bash' ]] && buildCmd='/bin/bash' ;

	## Validate arguments.
	supportedOS=(raspios debian-live debian-vbox pine64so)
	if ! (printf '%s\n' "${supportedOS[@]}" | grep -xq $baseOS); then
		echo "ERROR: Unsupported os." ; exit 1
	fi

	## Populate remove list
	populateRemoveList

	supportedArch=(armhf arm64 amd64)
	if ! (printf '%s\n' "${supportedArch[@]}" | grep -xq $cpuArch); then
		echo "ERROR: Unsupported cpu arch." ; exit 1
	fi

	## Setup the workspaces
	setupWorkSpace "$baseOS-$cpuArch"
	cacheDir="./cache/$baseOS-$cpuArch"
	workDir="./work/$baseOS-$cpuArch"
	releaseDir="./release/"
    vboxDir=$(pwd)/$workDir

	## Check if everything have been unmounted on the previous run.
	safetyChecks



###########
### Get the base OS
###########
(
	set -Eevo pipefail
	## If the source OS is not found in cache, download it.
	if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
		if [[ "$baseOS" == "raspios" ]]; then
			zipName="raspios_lite_${cpuArch}_latest"
			wget -P "$cacheDir/" "https://downloads.raspberrypi.org/$zipName"
			7z e -o"$cacheDir/" "$cacheDir/$zipName"
			mv "$cacheDir"/"$zipName"~ "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" == "pine64so" ]]; then
			zipName="Armbian_21.08.1_Pine64_bullseye_current_5.10.60.img.xz"
			wget -P "${cacheDir}/" "https://armbian.tnahosting.net/dl/pine64/archive/$zipName"
			7z e -o"${cacheDir}/" "${cacheDir}/${zipName}"
			mv "$cacheDir"/Armbian_??.??.?_Pine64_bullseye_current_?.??.??.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" =~ debian-* ]]; then
			wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-11.5.0-$cpuArch-standard+nonfree.iso"
			mv "$cacheDir/debian-live-11.5.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"

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

	#If no base vbox image exist
	if [[ $vbox && ! -f $vboxDir/lysmarine_dev_box.vdi ]]; then
		createVboxImage
	fi



###########
### Build lysmarine
###########
	if [[ $vbox && -f $vboxDir/lysmarine_dev_box.vdi ]]; then
		log "Mounting Vbox drive on host And copy lysmarine into it."
		cp $vboxDir/lysmarine_dev_box.vdi $vboxDir/lysmarine_dev_box.vdi.live

		vboxmanage list hdds
		vboximg-mount -i fb90d472-32ad-46bf-9257-9d29bce9e703 --rw --root  $vboxDir/dev/

        sleep 1 ; wait
        mount -v $vboxDir/dev/vol0 $vboxDir/mnt
		cp -r "../install-scripts" "$vboxDir/mnt"
		chmod 0775 "$vboxDir/mnt/install-scripts/install.sh"
 		ls -lah $vboxDir/mnt
		sync; wait; sleep 1

		umount $vboxDir/mnt
		umount $vboxDir/dev
		sync; wait; sleep 1

		vboxmanage closemedium disk fb90d472-32ad-46bf-9257-9d29bce9e703 || true
		sync; wait; sleep 1

		log "Start the machine "
		VBoxManage startvm lysmarine_dev_box --type=gui
		log "Vbox machine should be running by now, User and passwords are:  "
		log "ssh is port forwarded to 3022"
		exit
	fi

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
	cachedLayers=""
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
			cp -ra $workDir/$argument  $cacheDir/$argument
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
		rsync -haPr  "$cacheDir/iso/.disk" "$workDir/iso"

		cp files/preseed.cfg "$workDir/iso"
		cp files/splash.png "$workDir/iso/isolinux/"
		cp files/menu.cfg "$workDir/iso/isolinux/"
		cp files/stdmenu.cfg "$workDir/iso/isolinux/"
		wait

		xorriso -as mkisofs -V 'lysmarineOSlive-amd64' -o "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.iso" -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus "$workDir/iso"

	elif [ -f "$cacheDir/$baseOS-$cpuArch.base.img" ]; then
	 	cp $cacheDir/$baseOS-$cpuArch.base.img-inflated $workDir/$baseOS-$cpuArch.base.img-inflated
		wait
	 	mountSourceImage "$workDir/$baseOS-$cpuArch.base.img-inflated"
	 	cp -far $workDir/fakeLayer/* $workDir/mnt || true

		mv "$workDir/$baseOS-$cpuArch.base.img-inflated" "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img"
	fi



###########
### Cleanup workspace
###########

	umount -l $workDir/fakeLayer || true
	umount $workDir/mnt/boot || true
	umount $workDir/mnt || true

) || {
 	logErr "Build failed... cleaning the workspace." ;
	safetyChecks ;
	logErr "Build failed... :(" ;
}