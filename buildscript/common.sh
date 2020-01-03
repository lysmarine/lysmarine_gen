source lib.sh





function getCachedVendors {
        #pishrink is needed to deflate the disk size at the end
        if [ ! -f ./cache/pishrink.sh ] ; then
                log "Downloading pishrink."
                cd ./cache
                wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
                chmod +x pishrink.sh
                cd ..
        else
                log "Using pishrink from cache."

        fi

        # Download or copy the official image from cache
        if [ ! -f ./cache/$thisArch/$imageName ]; then
                log "Downloading official image from internet."
                wget -P ./cache/$thisArch/  $imageSource
                7z e -o./cache/$thisArch/   ./cache/$thisArch/$zipName
                rm ./cache/$thisArch/$zipName

        else
                log "Using official image from cache."

        fi

}


#function prepareBaseOs {

#	inflateImage $thisArch ./cache/$thisArch/$imageName
	# if [ ! -f ./cache/$thisArch/$imageName-inflated ]; then
	# 	log "Inflating OS image to have enough space to build lysmarine. "
	# 	cp -fv ./cache/$thisArch/$imageName ./cache/$thisArch/$imageName-inflated
	#
	# 	# Mounting image disk (but not the partitions yet)
	# 	log "Mounting image."
	# 	partQty=$(fdisk -l ./cache/$thisArch/$imageName-inflated | grep -o "^./cache/$thisArch/$imageName-inflated" | wc -l)
	#
	# 	echo $partQty partitions detected.
	# 	log "Resizing root partition."
	#
	# 	# Add 6G to the image file
	# 	truncate -s "6G" ./cache/$thisArch/$imageName-inflated
	#
	# 	# Inflate last partition to maximum available space.
	# 	parted ./cache/$thisArch/$imageName-inflated --script "resizepart $partQty 100%" ;
	#
	# 	#mount the inage drive
	# 	mountImageFile $thisArch ./work/$thisArch/$imageName
	#
	# 	log "Resize the root file system to fill the new drive size."
	# 	resize2fs /dev/mapper/loop${loopId}p$partQty
	#
	# 	log "Unmount OS image"
	# 	umountImageFile $thisArch ./work/$thisArch/$imageName
	#
	# else
	# 	log "Using Ready to build image from cache"
	# fi
#}#



function mountImage  {
        log "Mounting OS partitions."

				## Make sure it's not already mounted
				if [ ! -z "$(ls -A ./work/$thisArch/rootfs)" ]; then
					 logErr "./work/$thisArch/rootfs is not empty. Previous failiure to unmount ?"
					 exit
				fi

				# Mount the image and make the binds required to chroot.
				log "Mounting OS image."
				IFS=$'\n' #to split lines into array
				partitions=($(kpartx -sav ./work/$thisArch/$imageName |  cut -d" " -f3))
				partQty=${#partitions[@]}
				echo $partQty partitions detected.


				# mount partition table in /dev/loop
 			 loopId=$(kpartx -sav ./work/$thisArch/$imageName |  cut -d" " -f3 | grep -o "[^a-z]" | head -n 1)

        if [ $partQty == 2 ] ; then
                mount -v /dev/mapper/loop${loopId}p2 ./work/$thisArch/rootfs/
								if [ ! -d ./work/$thisArch/rootfs/boot ] ; then mkdir ./work/$thisArch/rootfs/boot ; fi
	              mount -v /dev/mapper/loop${loopId}p1 ./work/$thisArch/rootfs/boot/

        elif [ $partQty == 1 ] ; then
                mount -v /dev/mapper/loop${loopId}p1 ./work/$thisArch/rootfs/

        else
                log "ERROR: unsuported amount of partitions."
                exit 1
        fi

}


function mountImageInWork  {
        log "Mounting OS partitions."

				## Make sure it's not already mounted
				if [ ! -z "$(ls -A ./work/$thisArch/rootfs)" ]; then
					 logErr "./work/$thisArch/rootfs is not empty. Previous failiure to unmount ?"
					 exit
				fi

				# Mount the image and make the binds required to chroot.
				log "Mounting OS image."
				IFS=$'\n' #to split lines into array
				partitions=($(kpartx -sav ./work/$thisArch/$imageName |  cut -d" " -f3))
				partQty=${#partitions[@]}
				echo $partQty partitions detected.



        # mount partition table in /dev/loop
        loopId=$(kpartx -sav ./work/$thisArch/$imageName |  cut -d" " -f3 | grep -o "[^a-z]" | head -n 1)

        if [ $partQty == 2 ] ; then
        #
                mount -v /dev/mapper/loop${loopId}p2 ./work/$thisArch/rootfs/
                mount -v /dev/mapper/loop${loopId}p1 ./work/$thisArch/rootfs/boot/

        elif [ $partQty == 1 ] ; then
                mount -v /dev/mapper/loop${loopId}p1 ./work/$thisArch/rootfs/

        else
                log "ERROR: unsuported amount of partitions."
                exit 1
        fi

}



function umountImage {
	umount ./work/$thisArch/bootfs
	umount ./work/$thisArch/rootfs
	kpartx -d ./cache/$thisArch/$imageName-inflated

}



function mountAndBind {

	## Make sure it's not already mounted
	if [ ! -z "$(ls -A ./work/$thisArch/rootfs)" ]; then
		 logErr "./work/$thisArch/rootfs is not empty. Previous failiure to unmount ?"
		 exit
	fi

	# Mount the image and make the binds required to chroot.
	log "Mounting OS image."
	IFS=$'\n' #to split lines into array
	partitions=($(kpartx -sav ./work/$thisArch/$imageName |  cut -d" " -f3))
	partQty=${#partitions[@]}
	echo $partQty partitions detected.

	log "Mounting OS partitions."
	if [ $partQty == 2 ] ; then
		mount -v /dev/mapper/${partitions[1]} ./work/$thisArch/rootfs/
		mkdir ./work/$thisArch/rootfs/boot
		mount -v /dev/mapper/${partitions[0]} ./work/$thisArch/rootfs/boot/

	elif [ $partQty == 1 ] ; then
		mount -v /dev/mapper/${partitions[0]} ./work/$thisArch/rootfs/

	else
		log "ERROR: unsuported amount of partitions."
		exit 1
	fi

	resize2fs /dev/mapper/${partitions[ $(($partQty - 1)) ]}
}







# Unmount the image
function unmountOs {
	log "Unmounting partitions"
	umount /dev/mapper/${partitions[0]}
	umount /dev/mapper/${partitions[1]}
	kpartx -d ./work/$thisArch/$imageName
}
