#!/bin/bash -xe
{
	source lib.sh
	checkRoot

	#sudo ./build.sh raspios arm64

	# Usage: sudo ./build.sh baseOS processorArchitecture lmVersion stagesToBuild
	# Note : baseOs options are raspios|armbian-pine64so|debian-live|debian-vbox|debian.
	# Note : processorArchitecture armhf|arm64|amd64
	baseOS="${1:-raspios}"
	cpuArch="${2:-armhf}"
	lmVersion="${3:-nightBuild_$EPOCHSECONDS}"
	stagesToBuild="$4"

	setupWorkSpace "$baseOS-$cpuArch"
	cacheDir="./cache/$baseOS-$cpuArch"
	workDir="./work/$baseOS-$cpuArch"
	releaseDir="./release/"

	# if needed, download the base OS

	# if no source Os is found in cache, download it.
	if ! ls "$cacheDir/$baseOS-$cpuArch".base.??? >/dev/null 2>&1; then

		if [[ "$baseOS" == "raspios" ]]; then
			zipName="raspios_lite_${cpuArch}_latest"
			wget -P "$cacheDir/" "https://downloads.raspberrypi.org/$zipName"
			7z e -o"$cacheDir/" "$cacheDir/$zipName"
			mv "$cacheDir"/????-??-??-"$baseOS"-buster-"$cpuArch"-lite.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" == "armbian-pine64so" ]]; then
			zipName="Armbian_20.08.1_Pine64so_buster_current_5.8.5.img.xz"
			wget -P "${cacheDir}/" "https://dl.armbian.com/pine64so/archive/$zipName"
			7z e -o"${cacheDir}/" "${cacheDir}/${zipName}"
			mv "$cacheDir"/Armbian_??.??.?_Pine64so_buster_current_?.?.?.img "$cacheDir/$baseOS-$cpuArch.base.img"
			rm "$cacheDir/$zipName"

		elif [[ "$baseOS" =~ debian-* ]]; then
			wget -P "$cacheDir/" "http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current-live/$cpuArch/iso-hybrid/debian-live-10.6.0-$cpuArch-standard+nonfree.iso"
			mv "$cacheDir/debian-live-10.6.0-$cpuArch-standard+nonfree.iso" "$cacheDir/$baseOS-$cpuArch.base.iso"

		else
			echo "Unknown baseOS"
			exit 1
		fi
	fi

	# if it's an image, we assume that it will to be inflated
	if [[ ! -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" && -f "$cacheDir/$baseOS-$cpuArch.base.img" ]]; then
		inflateImage "$baseOS" "$cacheDir/$baseOS-$cpuArch.base.img"
	fi

	# if it's an image, we assume that it will need chroot to build
	if [ -f "$cacheDir/$baseOS-$cpuArch.base.img-inflated" ]; then
		rsync -P -auz "$cacheDir/$baseOS-$cpuArch.base.img-inflated" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		mountImageFile "$workDir" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		addLysmarineScripts "$workDir/rootfs"
		chrootWithProot "$workDir" "$cpuArch" "$stagesToBuild"
		umountImageFile "$workDir" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		shrinkWithPishrink "$cacheDir" "$workDir/$baseOS-$cpuArch.base.img-inflated"
		rsync -P -auz "$workDir/$baseOS-$cpuArch.base.img-inflated" "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.img"

	elif
		[[ "$baseOS" == 'debian-live' ]]
	then
		mountIsoFile "$workDir" "$cacheDir/${baseOS}-${cpuArch}.base.iso"
		addLysmarineScripts "$workDir/squashfs-root"

		if [[ $stagesToBuild == 'bash' ]]; then
			buildCmd='/bin/bash'
		else
			buildCmd="./install.sh $stagesToBuild"
		fi
		
		mount --rbind /dev $workDir/squashfs-root/dev/
		mount  -t proc /proc $workDir/squashfs-root/proc/
		mount --rbind /sys $workDir/squashfs-root/sys/
		cp /etc/resolv.conf  $workDir/squashfs-root/etc/
		chroot $workDir/squashfs-root /bin/bash <<EOT
cd /install-scripts ;
$buildCmd
EOT
		rm $workDir/squashfs-root/etc/resolv.conf
		umount  $workDir/squashfs-root/dev
		umount  $workDir/squashfs-root/proc
		umount  $workDir/squashfs-root/sys

		umountIsoFile "$workDir"

		# Re-squash the file system.
		pushd "$workDir/"
		mksquashfs squashfs-root/ ./filesystem.squashfs -comp xz -noappend -processors 8
		rm -r ./squashfs-root
		popd

		# Move the file system inside the new iso source location
		cp "$workDir/filesystem.squashfs" "$workDir/rootfs/live/filesystem.squashfs"

		# Create the iso
		xorriso -as mkisofs -V 'Debian 10.1 amd64 custom nonfree' -o "$releaseDir/lysmarine-$lmVersion-$baseOS-$cpuArch.iso" -J -J -joliet-long -cache-inodes -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus "$workDir/rootfs"

	elif [[ $baseOS == 'debian-vbox' ]]; then
		echo "not implemented yet"
		exit 1
	fi

	exit 0
}
