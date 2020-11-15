#!/bin/bash -xe
{
	source lib.sh
	checkRoot
	lmVersion=${2:-0.dev}
	cpuArch="${1:-armhf}"
	upstreamOS="raspios"
	thisArch=upstreamOS # $thisArch is deprecated, plz use $upstreamOS
	zipName="raspios_lite_${cpuArch}_latest"
	imageSource="https://downloads.raspberrypi.org/${zipName}"
	qemuArch="qemu-arm"

   if [ $cpuArch == arm64 ]; then
		qemuArch="qemu-aarch64"
   fi


	# Create caching folder hierarchy to work with this architecture.
	setupWorkSpace $upstreamOS
	cacheDir=./cache/$upstreamOS
	workDir=./work/$upstreamOS
	releaseDir=./release/

	# Download upstream image from internet
	if [ ! -f $cacheDir/????-??-??-${upstreamOS}-buster-${cpuArch}-lite.img ]; then
		wget -P $cacheDir/ $imageSource
		7z e -o$cacheDir/ $cacheDir/$zipName
		rm $cacheDir/$zipName
	fi

	# Copy image file to work folder add temporary space to it.
	imageName=$(ls $cacheDir/????-??-??-${upstreamOS}-buster-${cpuArch}-lite.img | xargs -n 1 basename)
	if [ ! -f $cacheDir/${imageName}-inflated ]; then
		inflateImage $upstreamOS $cacheDir/$imageName
	fi

	# copy ready image from cache to the work dir
	cp -fv $cacheDir/$imageName-inflated $workDir/$imageName

	# Mount the image and make the binds required to chroot.
	mountImageFile $upstreamOS $workDir/$imageName

	# Copy the lysmarine and origine OS config files in the mounted rootfs
	addLysmarineScripts $upstreamOS

	# chroot into the
	proot -q "$qemuArch" \
		--root-id \
		--rootfs=$workDir/rootfs \
		--cwd=/install-scripts \
		--mount=/etc/resolv.conf:/etc/resolv.conf \
		--mount=/dev:/dev \
		--mount=/sys:/sys \
		--mount=/proc:/proc \
		--mount=/tmp:/tmp \
		--mount=./cache/$thisArch/stageCache:/lysmarine/stageCache \
		--mount=/run/shm:/run/shm \
		./install.sh 0 2 4 6 8

	# Unmount
	umountImageFile $upstreamOS $workDir/$imageName

	# Shrink the image size.
	if [ ! -f $cacheDir/pishrink.sh ]; then
		wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh -P $cacheDir/
		chmod +x $cacheDir/pishrink.sh
	fi
	$cacheDir/pishrink.sh $workDir/$imageName

	# Renaming the OS and moving it to the release folder.
	cp -v $workDir/$imageName $releaseDir/lysmarine_${lmVersion}-${upstreamOS}-${cpuArch}.img

	exit 0
}
