#!/bin/bash -xe
{
  source lib.sh

  myCpuArch=$1
  LYSMARINE_VER=$2

  thisArch="raspOs"
  cpuArch="armhf"
  if [ "arm64" == "$myCpuArch" ]; then
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

  ls -l /run
  ls -l install-scripts
  ls -l $thisArch

  MK_ROOT=work/${thisArch}/rootfs
  mkdir -p ./cache/${thisArch}/stageCache; mkdir -p $MK_ROOT/install-scripts/stageCache
  mkdir -p /run/shm; mkdir -p $MK_ROOT/run/shm
  mount -o bind /etc/resolv.conf $MK_ROOT/etc/resolv.conf
  mount -o bind /dev $MK_ROOT/dev
  mount -o bind /sys $MK_ROOT/sys
  mount -o bind /proc $MK_ROOT/proc
  mount -o bind /tmp $MK_ROOT/tmp
  mount --rbind $myCache/stageCache $MK_ROOT/install-scripts/stageCache
  mount --rbind /run/shm $MK_ROOT/run/shm
  chroot work/${thisArch}/rootfs /bin/bash -xe << EOF > /tmp/lysmarine-mk-image.log
    set -x; set -e; cd /install-scripts; export LMBUILD="raspbian"; ls; chmod +x *.sh; ./install.sh; exit
EOF

  # Unmount
  umountImageFile $thisArch ./work/$thisArch/$imageName

  # Renaming the OS and moving it to the release folder.
  cp -v ./work/$thisArch/$imageName  ./release/$thisArch/lysmarine_${LYSMARINE_VER}-${thisArch}-${cpuArch}.img

  exit 0
}
