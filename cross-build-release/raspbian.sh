#!/bin/bash -xe
{
  source lib.sh

  MY_CPU_ARCH=$1
  LYSMARINE_VER=$2

  thisArch="raspios"
  cpuArch="armhf"
  if [ "arm64" == "$MY_CPU_ARCH" ]; then
    cpuArch="arm64"
  fi
  zipName="raspios_lite_${cpuArch}_latest"
  imageSource="https://downloads.raspberrypi.org/${zipName}"

  checkRoot

  # Create caching folder hierarchy to work with this architecture.
  setupWorkSpace $thisArch

  # Download the official image
  log "Downloading official image from internet."
  myCache=./cache/$thisArch
  wget -P $myCache/ $imageSource
  7z e -o$myCache/ $myCache/$zipName
  rm $myCache/$zipName

  # Copy image file to work folder add temporary space to it.
  imageName=$(cd $myCache; ls *.img; cd ../../)
  inflateImage $thisArch $myCache/$imageName

  # copy ready image from cache to the work dir
  cp -fv $myCache/$imageName-inflated ./work/$thisArch/$imageName

  # Mount the image and make the binds required to chroot.
  mountImageFile $thisArch ./work/$thisArch/$imageName

  # Copy the lysmarine and origine OS config files in the mounted rootfs
  addLysmarineScripts $thisArch

  mkRoot=work/${thisArch}/rootfs
  ls -l $mkRoot

  mkdir -p ./cache/${thisArch}/stageCache; mkdir -p $mkRoot/install-scripts/stageCache
  mkdir -p /run/shm; mkdir -p $mkRoot/run/shm
  mount -o bind /etc/resolv.conf $mkRoot/etc/resolv.conf
  mount -o bind /dev $mkRoot/dev
  mount -o bind /sys $mkRoot/sys
  mount -o bind /proc $mkRoot/proc
  mount -o bind /tmp $mkRoot/tmp
  mount --rbind $myCache/stageCache $mkRoot/install-scripts/stageCache
  mount --rbind /run/shm $mkRoot/run/shm
  chroot work/${thisArch}/rootfs /bin/bash -xe << EOF
    set -x; set -e; cd /install-scripts; export LMBUILD="raspios"; ls; chmod +x *.sh; ./install.sh; exit
EOF

  # Unmount
  umountImageFile $thisArch ./work/$thisArch/$imageName

  # Renaming the OS and moving it to the release folder.
  cp -v ./work/$thisArch/$imageName  ./release/$thisArch/lysmarine_${LYSMARINE_VER}-${thisArch}-${cpuArch}.img

  exit 0
}
