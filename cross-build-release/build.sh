#!/usr/bin/env bash
# shellcheck disable=SC2115

source lib.sh

###########
### Setup
###########

  checkRoot

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

	if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then
		if [[ "$baseOS" == "raspios" ]]; then
		  zipName="2023-10-10-raspios-bookworm-${cpuArch}-lite.img"
			wget -P "$cacheDir/" "https://downloads.raspberrypi.org/raspios_lite_${cpuArch}/images/raspios_lite_${cpuArch}-2023-10-10/$zipName".xz
			7z e -o"$cacheDir/" "$cacheDir/$zipName".xz
			mv "$cacheDir"/"$zipName" "$cacheDir/$baseOS-$cpuArch.base.img"
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
		inflateImage "$cacheDir/$baseOS-$cpuArch.base.img" "8000M"

	elif [[ -f "$cacheDir/$baseOS-$cpuArch.base.iso" && ! "$(ls -A $cacheDir/mnt/*)" ]]; then
	 	log "Extracting filesystem from base iso"
	 	7z x "$cacheDir/${baseOS}-${cpuArch}.base.iso" -o$cacheDir/iso
	 	unsquashfs s -f -d $cacheDir/mnt $cacheDir/iso/live/filesystem.squashfs
  else
    log "Reusing base image from cache."
	fi

###########
### Create a base image to build on
###########
	log "Mounting base image"
  if [[ "$baseOS" == "vagrant-debian"  ]]; then
	  log "vagrant up"
        installDirLocation=$(pwd)/../install-scripts
        pushd $cacheDir/Vagrant/
        vagrant destroy -f
        vagrant up
        vagrant ssh -c "sudo mkdir /install-scripts"
        vagrant ssh -c "sudo chmod 0777 /install-scripts"
        vagrant scp "$installDirLocation/" :/
        vagrant ssh -c "sudo chmod 0755 /install-scripts"
        vagrant ssh -c "cd /install-scripts ; sudo ./install.sh ${stages}"
        popd
    exit 0

  elif [ -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" ]; then
    rm $workDir/$baseOS-$cpuArch.base.img-inflated || true
    cp $cacheDir/$baseOS-$cpuArch.base.img-inflated $workDir/$baseOS-$cpuArch.base.img-inflated &
    mountSourceImage $cacheDir/$baseOS-$cpuArch.base.img-inflated $workDir/mnt

  elif [ -f "$cacheDir/$baseOS-$cpuArch.base.iso" ]; then
    cp -r $cacheDir/iso/. $workDir/iso &
    mount --bind $cacheDir/mnt $workDir/mnt
    # TODO mount directly the squashfs # sudo mount -o loop -t squashfs /path/to/sage-x.y.z.sqfs /path/to/sage-x.y.z.

  else
    logErr "No base layer found for overlayFS"
    exit 1

  fi



###########
### Build stages by stages
###########
	set -f
	cachedLayers=""
	for argument in $stages; do # Loop each requested stages to build

		# Remove requested stages from cache
		if [[ "$remove" == *"$argument"* ]]; then
			[[ -d $cacheDir/$argument ]] && rm -r "${cacheDir}/${argument}" && log "    $argument removed"
		fi

		if [ -d "$cacheDir/$argument" ] ; then # if the stage is already available in the cache, use it instead of building it.
			log "    Stage $argument have been found in cache, adding it as lowerdir"
			cachedLayers="$cacheDir/$argument:$cachedLayers"

		else # mount and build
	  		log     "Building stage $argument"
			rm -r "$workDir/$argument" || true
			mkdir "$workDir/$argument"
       		mount.mergerfs "$workDir/mnt" "$workDir/mergedMnt"
      		mount -t overlay overlay -o "lowerdir=${cachedLayers}${workDir}/mergedMnt,upperdir=${workDir}/${argument},workdir=${workDir}/workdir" "${workDir}/fakeLayer"
			
			buildCmd="./install.sh $argument"
    		chrootAndBuild

			umount "$workDir/fakeLayer" || umount -l "$workDir/fakeLayer" || logErr "Fail to unmount $workDir/fakeLayer"
			umount "$workDir/mergedMnt" || umount -l "$workDir/mergedMnt" || logErr "Fail to unmount $workDir/mergedMnt"
			rm -r "$cacheDir/$argument" || true ;
			mv "$workDir/$argument" "$cacheDir/$argument" ;
			rm -r "$workDir/$argument" &

			[ -f cachedLayers ] && cachedLayers=":"
			cachedLayers="$cacheDir/$argument:$cachedLayers"
		fi

	done



###########
### Repackage the OS for shipping
###########
  log "Packaging OS"
  mount.mergerfs $workDir/mnt $workDir/mergedMnt
  mount -t overlay overlay -o "lowerdir=${cachedLayers}$workDir/mergedMnt" "$workDir/fakeLayer"
  wait

	if [ -d "$workDir/iso" ]; then
		mkdir "$workDir/iso/live"
    	#mksquashfs "$workDir/fakeLayer" "$workDir/iso/live/filesystem.squashfs" -comp xz -noappend
    	mksquashfs "$workDir/fakeLayer" "$workDir/iso/live/filesystem.squashfs" -comp gzip -noappend
    	md5sum "$workDir/iso/live/filesystem.squashfs"
		rsync -haPr  "$cacheDir/iso/.disk" "$workDir/iso"

		cp files/preseed.cfg "$workDir/iso"
		cp files/splash.png "$workDir/iso/isolinux/"
		cp files/menu.cfg "$workDir/iso/isolinux/"
		cp files/stdmenu.cfg "$workDir/iso/isolinux/"
    #	header image of the GUI installer is in :  iso/d-i/gtk/ initrd --> /usr/share/graphics.

    xorriso -as mkisofs -V 'lysmarineOSlive-amd64' -o "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.iso" -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus "$workDir/iso" ;
    rm -r "$workDir/iso" &

	elif [ -f "$workDir/$baseOS-$cpuArch.base.img-inflated" ]; then
	 	mountSourceImage "$workDir/$baseOS-$cpuArch.base.img-inflated" $workDir/releaseMnt
	 	parted "$workDir/$baseOS-$cpuArch.base.img-inflated" --script "print"
    rsync -arHAX "$workDir/fakeLayer/" "$workDir/releaseMnt" --delete

    umount "$workDir/releaseMnt/boot" || true
    umount "$workDir/releaseMnt" || true

    kpartx -d "$workDir/$baseOS-$cpuArch.base.img-inflated"
    parted "$workDir/$baseOS-$cpuArch.base.img-inflated" --script "print"
    mv "$workDir/$baseOS-$cpuArch.base.img-inflated" "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img"
    parted "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img" --script "print"
    kpartx -d "$cacheDir/$baseOS-$cpuArch.base.img"

	  echo -e "PRO-TIP: \033[1;34m sudo su -c 'pv -tpreb ./release/lysmarine-$lmVersion-$baseOS-$cpuArch.img | dd of=/dev/mmcblk0 status=noxfer ; sync' \e[0m"

	else
	  logErr "Nothing to package"
	fi



###########
### Cleanup workspace
###########

	umount -l "$workDir/fakeLayer" || true
  umount "$workDir/mergedMnt"
	umount "$workDir/mnt/boot" || true
	umount "$workDir/mnt" || true

) || {
 	logErr "Build failed... cleaning the workspace." ;
	safetyChecks ;
	logErr "Build failed... " ;
}