#!/bin/bash
source lib.sh
###########
### Setup
###########

  checkRoot

  supportedOS=(raspios debian-live vagrant-debian pine64so)
  supportedArch=(armhf arm64 amd64)
  setArguments "$@"

	## Setup the workspaces
	cacheDir="./cache/$baseOS-$cpuArch"
	workDir="./work/$baseOS-$cpuArch"
	releaseDir="./release/"

	setupWorkSpace

	safetyChecks

	populateStageList

	populateRemoveList

###########
### Download the base OS
###########
(
	set -Eevo pipefail

	## If the source OS is not found in cache, download it.
	if [[ "$baseOS" == "vagrant-debian"  ]]; then
	  if [[ ! -d $cacheDir/Vagrant ]]; then
	    log "Init vagrant"
      mkdir $cacheDir/Vagrant
      cp ./files/Vagrantfile $cacheDir/Vagrant/
      vagrant plugin install vagrant-scp
      pushd $cacheDir/Vagrant/
        vagrant init
      popd
    fi

	elif ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
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
  else
    log "Original image found in cache."
	fi


###########
### Prepare the base OS
###########
	if [[  -f "$cacheDir/$baseOS-$cpuArch.base.img" && ! -f $cacheDir/$baseOS-$cpuArch.base.img-inflated ]]; then
	  log "Inflating base image"
		inflateImage "$baseOS" "$cacheDir/$baseOS-$cpuArch.base.img"

	elif [[ -f "$cacheDir/$baseOS-$cpuArch.base.iso" && ! "$(ls -A $cacheDir/mnt/*)" ]]; then
	 	log "Extracting filesystem from base iso"
	 	7z x "$cacheDir/${baseOS}-${cpuArch}.base.iso" -o$cacheDir/iso
	 	unsquashfs s -f -d $cacheDir/mnt $cacheDir/iso/live/filesystem.squashfs
  else
    log "Reusing base image from cache."
	fi


###########
### Prepare to Build lysmarine
###########
	log "Mounting base image"
  if [[ $vagrant ]]; then
	  log "vagrant up"
        installDirLocation=$(pwd)/../install-scripts
        pushd $cacheDir/Vagrant/
        vagrant destroy -f
        vagrant up
        vagrant ssh -c "sudo mkdir /install-scripts"
        vagrant ssh -c "sudo chmod 0777 /install-scripts"
        vagrant scp $installDirLocation/ :/
        vagrant ssh -c "sudo chmod 0755 /install-scripts"
        vagrant ssh -c "cd /install-scripts ; sudo ./install.sh ${stages}"
        popd
    exit 0

  elif [ -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" ]; then
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
      [[ -d $cacheDir/$argument ]] && rm -r $cacheDir/$argument && log "    $argument removed"
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