#! /bin/bash
source common.sh



if [ -z "$1"  ]; then
	echo "Plz provide the arch to use as argument"
	echo ""
	ls ./release
	echo ""
	exit
fi



thisArch=$1
imageName=$( ls ./release/$thisArch/ )



if [ ! -d ./cache/$thisArch/qemu-rpi-kernel-master ]; then
	log "Download qemu-rpi-kernel"
		wget -P ./cache/$thisArch/ https://github.com/dhruvvyas90/qemu-rpi-kernel/archive/master.zip
		unzip ./cache/$thisArch/master.zip -d ./cache/$thisArch/
		rm ./cache/$thisArch/master.zip
else
	log "Use qemu-rpi-kernel from cache"
fi



cp -v ./release/$thisArch/$imageName ./work/$thisArch/test.img
partQty=$(fdisk -l ./work/$thisArch/test.img | grep -o "^./work/$thisArch/test.img" | wc -l)
truncate -s "5G" ./work/$thisArch/test.img
parted ./work/$thisArch/test.img --script "resizepart $partQty 100%" ;



if [ "$thisArch" == "raspbian" ]; then

	qemu-system-arm \
		 -kernel ./cache/$thisArch/qemu-rpi-kernel-master/kernel-qemu-4.19.50-buster \
		 -cpu arm1176 \
		 -m 256 \
		 -M versatilepb \
		 -hda ./work/$thisArch/test.img \
		 -serial stdio \
		 -dtb ./cache/$thisArch/qemu-rpi-kernel-master/versatile-pb.dtb \
		 -append  "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
		 -net user,hostfwd=tcp::${#thisArch}2-:22 \
		 -net nic

else
	echo "arch not supported"

fi
