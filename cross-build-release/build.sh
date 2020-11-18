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

	# if no source Os is found in cache, download it.
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
		   wget -P "${cacheDir}/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/${cpuArch}/iso-hybrid/debian-live-10.6.0-${cpuArch}-standard+nonfree.iso"
		   mv "${cacheDir}/debian-live-10.6.0-${cpuArch}-standard+nonfree.iso" "$cacheDir/${baseOS}-${cpuArch}.base.iso"

	   else
	    echo "Unknown baseOS" ; exit 1 ;
	   fi
   fi

   # if it's an image, we assume that it will to be inflated
   if [[ ! -f "$cacheDir/${baseOS}-${cpuArch}.base.img-inflated" && -f "$cacheDir/${baseOS}-${cpuArch}.base.img" ]]; then
	   inflateImage $baseOS "$cacheDir/${baseOS}-${cpuArch}.base.img"
   fi

	# if it's an image, we assume that it will need chroot to build
   if [ -f "$cacheDir/${baseOS}-${cpuArch}.base.img-inflated" ]; then
	  rsync -P -auz "$cacheDir/${baseOS}-${cpuArch}.base.img-inflated" "$workDir/${baseOS}-${cpuArch}.base.img-inflated"
	  mountImageFile $workDir "$workDir/${baseOS}-${cpuArch}.base.img-inflated"
	  addLysmarineScripts $workDir/rootfs
	  chrootWithProot $workDir $cpuArch $stagesToBuild
	  umountImageFile $workDir $workDir/${baseOS}-${cpuArch}.base.img-inflated
	  shrinkWithPishrink cacheDir "$workDir/${baseOS}-${cpuArch}.base.img-inflated"
	  rsync -P -auz $workDir/${baseOS}-${cpuArch}.base.img-inflated $releaseDir/lysmarine-${lmVersion}-${baseOS}-${cpuArch}.img

   elif [[ $baseOS == 'debian-vbox' ]];then
 #     rsync -P -auz "$cacheDir/${baseOS}-${cpuArch}.base.iso" "$workDir/${baseOS}-${cpuArch}.base.iso"
#	  MACHINENAME=lysmarine
echo "not yet"
   elif [[ $baseOS == 'debian-live' ]];then
	   mount -o loop "$cacheDir/${baseOS}-${cpuArch}.base.iso" $workDir/isomount
		   cp -a $workDir/isomount/live/filesystem.squashfs $workDir/
		   cp -a $workDir/isomount/* $workDir/rootfs
		   cp -a $workDir/isomount/.disk $workDir/rootfs
	   umount $workDir/isomount

	   pushd $workDir/
		   unsquashfs ./filesystem.squashfs
	   popd

	   mount --bind /dev $workDir/squashfs-root/dev
	   mount --bind /sys $workDir/squashfs-root/sys
	   mount --bind /proc $workDir/squashfs-root/proc
		   addLysmarineScripts $workDir/squashfs-root
buildCmd="./install.sh ${stagesToBuild}"
		   proot  \
	  --root-id \
	  --rootfs=$workDir/squashfs-root \
	  --cwd=/install-scripts \
	  --mount=/etc/resolv.conf:/etc/resolv.conf \
	  --mount=/dev:/dev \
	  --mount=/sys:/sys \
	  --mount=/proc:/proc \
	  --mount=/tmp:/tmp \
	  --mount=/run/shm:/run/shm \
	  /bin/bash

	   umount $workDir/squashfs-root/dev
	   umount $workDir/squashfs-root/sys
	   umount $workDir/squashfs-root/proc

	   pushd $workDir/
		   mksquashfs squashfs-root/ ./filesystem.squashfs -comp xz -noappend
	   popd
		rm -r $workDir/squashfs-root

	   cp $workDir/filesystem.squashfs $workDir/rootfs/live/filesystem.squashfs

	   pushd $workDir/rootfs
		 xorriso -as mkisofs -V 'Debian 10.1 amd64 custom nonfree' -o $releaseDir/lysmarine-${lmVersion}-${baseOS}-${cpuArch}.iso -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus ./
	   popd

	elif [[ $baseOS == 'debian-image' ]];then
	   echo "not yet"
	fi

exit 0 ;
}
