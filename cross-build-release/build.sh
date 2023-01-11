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
		logErr "ERROR: Unsupported os." ; exit 1
	fi

	## Populate the list of cached build stage to remove.
	populateRemoveList

	supportedArch=(armhf arm64 amd64)
	if ! (printf '%s\n' "${supportedArch[@]}" | grep -xq $cpuArch); then
		logErr "ERROR: Unsupported cpu arch." ; exit 1
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
### Download the base OS
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

		elif [[ "$baseOS" =~ debian-* ]]; then	#debian-live-11.6.0-amd64-standard+nonfree.iso
			wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-11.6.0-$cpuArch-standard+nonfree.iso"
			mv "$cacheDir/debian-live-11.6.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"

		fi
	fi



###########
### Extract the base OS
###########
	if [[  -f "$cacheDir/$baseOS-$cpuArch.base.img" && ! -f $cacheDir/$baseOS-$cpuArch.base.img-inflated ]]; then
	  log "Inflating base image"
		inflateImage "$baseOS" "$cacheDir/$baseOS-$cpuArch.base.img"

	elif [[ -f "$cacheDir/$baseOS-$cpuArch.base.iso" && ! "$(ls -A $cacheDir/mnt/*)" ]]; then
	 	log "Extracting filesystem from base iso"
	 	7z x "$cacheDir/${baseOS}-${cpuArch}.base.iso" -o$cacheDir/iso
	 	unsquashfs  -f -d $cacheDir/mnt $cacheDir/iso/live/filesystem.squashfs
	fi

	#If no base vbox image exist
#	if [[ $vbox && ! -f $vboxDir/lysmarine_dev_box.vdi ]]; then
#		createVboxImage
#	fi





#	if [[ $vbox && -f $vboxDir/lysmarine_dev_box.vdi ]]; then
#		log "Mounting Vbox drive on host And copy lysmarine into it."
#		cp $vboxDir/lysmarine_dev_box.vdi $vboxDir/lysmarine_dev_box.vdi.live
#		vboxmanage list hdds | grep "^UUID:"
#		vboxdisk=fb90d472-32ad-46bf-9257-9d29bce9e703
#		vboximg-mount -i $vboxdisk --rw --root  $vboxDir/dev/
#
#        sleep 1 ; wait
#        mount -v $vboxDir/dev/vol0 $vboxDir/mnt
#		cp -r "../install-scripts" "$vboxDir/mnt"
#		chmod 0775 "$vboxDir/mnt/install-scripts/install.sh"
#		sync; wait; sleep 1
#
#		umount $vboxDir/mnt
#		umount $vboxDir/dev
#		sync; wait; sleep 1
#
#		vboxmanage closemedium disk $vboxdisk || vboxmanage startvm $vboxdisk --type emergencystop
#
#		sync; wait; sleep 1
#
#		log "Start the machine "
#		VBoxManage startvm lysmarine_dev_box --type=gui
#		log "Vbox machine should be running by now, User and passwords are:  "
#		log "ssh is port forwarded to 3022"
#		exit
#	fi

	# For better performance, preemptively start copying the baseOs from cache for the Repackage phase .



###########
### Prepare to Build lysmarine
###########
	log "Mounting base image"

  if [ -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" ]; then
    rm $workDir/$baseOS-$cpuArch.base.img-inflated || true
    cp $cacheDir/$baseOS-$cpuArch.base.img-inflated $workDir/$baseOS-$cpuArch.base.img-inflated &
    mountSourceImage $cacheDir/$baseOS-$cpuArch.base.img $workDir/mnt

  elif [ -f "$cacheDir/$baseOS-$cpuArch.base.iso" ]; then
    cp -r $cacheDir/iso/. $workDir/iso &
    mount --bind $cacheDir/mnt $workDir/mnt
    # TODO mount directly the squashfs # sudo mount -o loop -t squashfs /path/to/sage-x.y.z.sqfs /path/to/sage-x.y.z.

  else
    logErr "No base layer found for overlayFS"
    exit 1

  fi



###########
### Loop stages
###########
	set -f
	cachedLayers=""
	for argument in $stages; do # Loop each requested stages to build

    if [[ "$remove" == *"$argument"* ]]; then
      log "    Removing stage $argument"
      rm -r $cacheDir/$argument
    fi

		if [ -d $cacheDir/$argument ] ; then # if the stage is already available in the cache, use it instead of building it.
			log "    Stage $argument have been found in cache, adding it as lowerdir"
			cachedLayers="$cacheDir/$argument:$cachedLayers"

		else # mount and build
	  	log     "Building stage $argument"
      rm -r "$workDir/$argument" || true
			mkdir $workDir/$argument

			mount -t overlay -o lowerdir=${cachedLayers}$workDir/mnt,upperdir=$workDir/$argument,workdir=$workDir/workdir none $workDir/fakeLayer
	    addLysmarineScripts "$workDir/fakeLayer"
			buildCmd="./install.sh $argument"
    	chrootAndBuild

			umount $workDir/fakeLayer || umount -l $workDir/fakeLayer || logErr "Fail to unmount $workDir/fakeLayer"
			rm -r $cacheDir/$argument || true ;
			mv $workDir/$argument  $cacheDir/$argument ;
			rm -r "$workDir/$argument" &

			[ -f cachedLayers ] && cachedLayers=":"
			cachedLayers="$cacheDir/$argument:$cachedLayers"
		fi

	done
  set +f


###########
### Repackage the OS for shipping
###########
  log "Packaging OS"
	mount -t overlay overlay -o lowerdir=${cachedLayers}$cacheDir/mnt $workDir/fakeLayer

	# Merging build layers in the BaseOs that will be shipped.
	if [ -d "$workDir/iso" ]; then
		mkdir "$workDir/iso/live"

		mksquashfs "$workDir/fakeLayer" "$workDir/iso/live/test.squashfs" -comp gzip -noappend &
		#md5sum "$workDir/iso/live/filesystem.squashfs"
		rsync -haPr  "$cacheDir/iso/.disk" "$workDir/iso"

		cp files/preseed.cfg "$workDir/iso"
		cp files/splash.png "$workDir/iso/isolinux/"
		cp files/menu.cfg "$workDir/iso/isolinux/"
		cp files/stdmenu.cfg "$workDir/iso/isolinux/"
		wait

		xorriso -as mkisofs -V 'lysmarineOSlive-amd64' -o "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.iso" -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus $workDir/iso ;
    rm -r "$workDir/iso" &


	elif [ -f "$workDir/$baseOS-$cpuArch.base.img-inflated" ]; then

		wait
	 	mountSourceImage "$workDir/$baseOS-$cpuArch.base.img-inflated" $workDir/releaseMnt

	 	cp -far $workDir/fakeLayer/* $workDir/releaseMnt

    umount $workDir/releaseMnt/boot || true
    umount $workDir/releaseMnt || true

		mv -v "$workDir/$baseOS-$cpuArch.base.img-inflated" "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img"

		echo "PRO-TIP: \e[2m sudo su -c 'pv -tpreb ./release/lysmarine-$lmVersion-$baseOS-$cpuArch.img | dd of=/dev/mmcblk0 status=noxfer ; sync' "
	else
	  logErr "Nothing to package"
	fi



###########
### Cleanup workspace
###########

	umount -l $workDir/fakeLayer || true
	umount $workDir/mnt/boot || true
	umount $workDir/mnt || true
wait
) || {
 	logErr "Build failed... cleaning the workspace." ;
	safetyChecks ;
	logErr "Build failed... :(" ;
}