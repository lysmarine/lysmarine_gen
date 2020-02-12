#! /bin/bash

source lib.sh


if [ -z "$1"  ]; then
	echo "Plz provide the arch to use as argument"
	echo ""
	ls ./release
	echo ""
	exit
fi

thisArch=$1
imageName=$( ls ./release/$thisArch/ )

if [ ! -f ./work/$thisArch/test.img ]; then
	log "Build test image from cache"
	cp -v ./release/$thisArch/$imageName ./work/$thisArch/test.img
	truncate -s "7G" ./work/$thisArch/test.img
	
else
	log "Use test image from cache"
fi





if [ "$thisArch" == "raspbian" ]; then
	if [ ! -f ./cache/$thisArch/kernel-qemu-4.19.50-buster ]; then
		log "Download qemu-rpi-kernel"
			wget -P ./cache/$thisArch/ https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.19.50-buster 
	else
		log "Use qemu-rpi-kernel from cache"
	fi

	qemu-system-arm \
		-kernel ./cache/$thisArch/kernel-qemu-4.19.50-buster  \
		-cpu  arm1176\
		-m 256 \
		-serial stdio \
		-M versatilepb \
		-hda ./work/$thisArch/test.img \
		-dtb ./cache/$thisArch/qemu-rpi-kernel-master/versatile-pb.dtb \
		-append  "root=/dev/sda2 panic=1" \
		-net user,hostfwd=tcp::5022-:22,hostfwd=tcp::5080-:80,hostfwd=tcp::5090-:5900 \
		-net nic

else
	echo "arch not supported"

fi
