#!/bin/bash -xe
{
 source lib.sh
 checkRoot

	#sudo ./build.sh raspios arm64

 	# Usage: sudo ./build.sh baseOS processorArchitecture lmVersion stagesToBuild
	# Note : baseOs options are raspios|armbian-pine64so|debian-live|debian-vbox|debian.
	# Note : processorArchitecture armhf|arm64|amd64
	baseOS="${1:raspios}"
	cpuArch="${2:armhf}"
	lmVersion="${3:dev}"
	stagesToBuild="${4}"


	setupWorkSpace "$baseOS-$cpuArch"
	cacheDir="./cache/$baseOS-$cpuArch"
	workDir="./work/$baseOS-$cpuArch"
	releaseDir="./release/"

	# if needed, download the base OS

	if ! ls ${cacheDir}/${baseOS}-${cpuArch}.base.??? > /dev/null 2>&1; then

	   if [[ "${baseOS}" == "raspios" ]]; then
			 zipName="raspios_lite_${cpuArch}_latest"
			 wget -P "${cacheDir}/" "https://downloads.raspberrypi.org/${zipName}"
			 7z e -o"${cacheDir}/" "${cacheDir}/${zipName}"
			 mv ${cacheDir}/????-??-??-${baseOS}-buster-${cpuArch}-lite.img "$cacheDir/${baseOS}-${cpuArch}.base.img"
			 rm "${cacheDir}/${zipName}"

	   elif [[ "$baseOS" == "armbian-pine64so" ]]; then
		     zipName="Armbian_20.08.1_Pine64so_buster_current_5.8.5.img.xz"
		     wget -P "${cacheDir}/" "https://dl.armbian.com/pine64so/archive/${zipName}"
			 7z e -o"${cacheDir}/" "${cacheDir}/${zipName}"
			 mv ${cacheDir}/Armbian_??.??.?_Pine64so_buster_current_?.?.?.img "$cacheDir/${baseOS}-${cpuArch}.base.img"
			 rm "${cacheDir}/${zipName}"

	   elif [[ "$baseOS" =~ debian-* ]]; then
		   wget -P "${cacheDir}/" "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.6.0-${cpuArch}-netinst.iso"
		   mv "debian-10.6.0-${cpuArch}-netinst.iso" "$cacheDir/${baseOS}-${cpuArch}.base.iso"

	   else
	    echo "Unknown baseOS" ; exit 1 ;
	   fi
   fi

   if [[ ! -f "$cacheDir/${baseOS}-${cpuArch}.base.img-inflated" && -f "$cacheDir/${baseOS}-${cpuArch}.base.img" ]]; then
	   inflateImage $baseOS "$cacheDir/${baseOS}-${cpuArch}.base.img"
   fi

   if [ -f "$cacheDir/${baseOS}-${cpuArch}.base.img-inflated" ]; then
	  rsync --info=progress2 -auz "$cacheDir/${baseOS}-${cpuArch}.base.img-inflated" "$workDir/${baseOS}-${cpuArch}.base.img-inflated"
	  mountImageFile $workDir "$workDir/${baseOS}-${cpuArch}.base.img-inflated"
	  addLysmarineScripts $workDir
	  chrootWithProot $workDir $cpuArch $stagesToBuild
	  umountImageFile $workDir $workDir/${baseOS}-${cpuArch}.base.img-inflated
	  shrinkWithPishrink cacheDir "$workDir/${baseOS}-${cpuArch}.base.img-inflated"
	  rsync --info=progress2 -auz $workDir/${baseOS}-${cpuArch}.base.img-inflated $releaseDir/lysmarine-${lmVersion}-${baseOS}-${cpuArch}.img

   fi



	# Renaming the OS and moving it to the release folder.

	exit 0


exit 0 ;
}
