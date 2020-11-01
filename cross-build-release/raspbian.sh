#!/bin/bash -xe
{
	source lib.sh
	checkRoot
	LYSMARINE_VER=${LYSMARINE_VER:-0.dev}
	cpuArch="${1:-armhf}"
	upstreamOS="${2:-raspios}"
  	thisArch=upstreamOS # $thisArch is deprecated, plz use $upstreamOS
	zipName="raspios_lite_${cpuArch}_latest"
	imageSource="https://downloads.raspberrypi.org/${zipName}"

	# Create caching folder hierarchy to work with this architecture.
	setupWorkSpace $upstreamOS
	cacheDir=./cache/$upstreamOS
	workDir=./work/$upstreamOS
	releaseDir=./dir/$upstreamOS

	# Download upstream image from internet
  	if [ ! -f $cacheDir/????-??-??-${upstreamOS}-buster-${cpuArch}-lite.img ]; then
    	wget -P $cacheDir/ $imageSource
  		7z e -o$cacheDir/ $cacheDir/$zipName
  		rm $cacheDir/$zipName
	fi

    # Copy image file to work folder add temporary space to it.
  	imageName=$(ls $cacheDir/????-??-??-${upstreamOS}-buster-${cpuArch}-lite.img | xargs -n 1 basename;)
  	if [ ! -f $cacheDir/${imageName}-inflated ]; then
  		inflateImage $upstreamOS $cacheDir/$imageName
	fi

	# copy ready image from cache to the work dir
	cp -fv $cacheDir/$imageName-inflated $workDir/$imageName

	# Mount the image and make the binds required to chroot.
	mountImageFile $upstreamOS $workDir/$imageName

	# Copy the lysmarine and origine OS config files in the mounted rootfs
	addLysmarineScripts $upstreamOS

  mkRoot=$workDir/rootfs
  ls -l $mkRoot

  mkdir -p ./cache/${thisArch}/stageCache; mkdir -p $mkRoot/install-scripts/stageCache
  mkdir -p /run/shm; mkdir -p $mkRoot/run/shm
  mount -o bind /etc/resolv.conf $mkRoot/etc/resolv.conf
  mount -o bind /dev $mkRoot/dev
  mount -o bind /sys $mkRoot/sys
  mount -o bind /proc $mkRoot/proc
  mount -o bind /tmp $mkRoot/tmp
  mount --rbind /run/shm $mkRoot/run/shm
  chroot $mkRoot /bin/bash -xe << EOF
    set -x; set -e; cd /install-scripts; export LMBUILD="raspios"; ls; chmod +x *.sh; ./install.sh 0 2 4 6 8; exit
EOF

  # Unmount
  umountImageFile $upstreamOS $workDir/$imageName

  # Shrink the image size.
  if [ ! -f $cacheDir/pishrink.sh ]; then
	wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh -P $cacheDir/
	chmod +x .$cacheDir/pishrink.sh
  fi
  $cacheDir/pishrink.sh $workDir/$imageName

  # Renaming the OS and moving it to the release folder.
  cp -v $workDir/$imageName  $releaseDir/lysmarine_${LYSMARINE_VER}-${upstreamOS}-${cpuArch}.img

  exit 0
}
