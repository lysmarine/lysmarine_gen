log () {
          echo -e "\e[32m["$(date +'%T' )"]  \e[1m $1 \e[0m " #| tee -a "${LOG_FILE}"
}


logError () {
          echo -e "\e[91m ["$(date +'%T' )"] ---> $1 \e[0m" #| tee -a "${LOG_FILE}"
}



prepare_qemu_for () {
        case "$1" in
        RPi-ARMv6)
            if [ ! -d ./cache/$1/qemu-rpi-kernel-master ]; then
              log "Download qemu-rpi-kernel"
                wget -P ./cache/$1/ https://github.com/dhruvvyas90/qemu-rpi-kernel/archive/master.zip
                unzip ./cache/$1/master.zip -d ./cache/$1/
                rm ./cache/$1/master.zip
            else
              log "Use qemu-rpi-kernel from cache"
            fi

            export QEMU_FLAGS=(qemu-system-arm
                -kernel ./cache/$1/qemu-rpi-kernel-master/kernel-qemu-4.14.79-stretch \
                -cpu arm1176 \
                -m 256 \
                -M versatilepb \
                -no-reboot \
                -serial stdio \
                -dtb ./cache/$1/qemu-rpi-kernel-master/versatile-pb.dtb \
                -append  "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
                -drive file=$2,index=0,media=disk,format=raw \
                -net user,hostfwd=tcp::${#1}${#2}2-:22 \
                -net nic
            )

            ;;

        v6.0_NativePC-EFI-x86_64)

            export QEMU_FLAGS=(qemu-system-x86_64
                -m 256 \
                -no-reboot \
                -serial stdio \
                -boot d \
                -cdrom "$3" \
                -drive file=$2,index=0,media=disk,format=raw \
                -net user,hostfwd=tcp::${#1}${#2}2-:22 \
                -net nic
                )

            ;;
        v6.0_NativePC-BIOS-x86_64)
            # export QEMU_FLAGS=(qemu-system-x86_64
            #     -m 256 \
            #     -no-reboot \
            #     -serial stdio \
            #     -boot d \
            #     -cdrom "$3" \
            #     -drive file=$2,index=0,media=disk,format=raw \
            #     -net user,hostfwd=tcp::${#1}${#2}2-:22 \
            #     -net nic
            #     )

                      ;;
        *)
            logError "unknown SBC"
            exit 1

        esac
}


run_stage () {
        # Exported variables to be used instde stage files.
        export THIS_SBC=$1
        export ROOTFS="$(pwd)/work/$THIS_SBC/rootfs"
        export BOOTFS="$(pwd)/work/$THIS_SBC/bootfs"
        export STAGE_PATH=$(dirname "${2}")

        stageFileToExec=$2
        imageFile=$3
        bootPartition=$(fdisk -l $imageFile | grep -e "^$imageFile" | grep "*" | cut -d" " -f1 | sed --expression="s@$imageFile@ @g")

        log "Mount The OS"

        sudo kpartx -sa $imageFile

        # sudo /sbin/losetup --list
        sudo mount /dev/mapper/loop0p1 $BOOTFS
        sudo mount /dev/mapper/loop0p2 $ROOTFS
        ./$stageFileToExec
        log "Unmount The OS"
        sudo umount ./work/$1/bootfs
        sudo umount $ROOTFS
        sudo kpartx -vd $3
}
export -f run_stage


on_chroot() {
        ARCH=$1
        ROOTFS=$2
        CMD=$3

        # ld.so.preload fix
        sed -i 's/^/#/g' $ROOTFS/etc/ld.so.preload

        # copy qemu binary
        cp /usr/bin/qemu-arm-static $ROOTFS/usr/bin/

        wd=$(pwd)
        cd $ROOTFS
        sudo proot -r $ROOTFS -q qemu-arm -S $ROOTFS <<<"$3"

        cd $wd
        sed -i 's/^#//g' $ROOTFS/etc/ld.so.preload
}
export -f on_chroot



mount_image() {
        IMAGE=$1
        BOOTFS=$(pwd)/$2
        ROOTFS=$(pwd)/$3

        #mount partitions
        kpartx -sa $IMAGE

        loop=$(losetup -j $IMAGE |  cut -d":" -f1 | sed "s/\/dev\/loop//g" ) #

         IFS=$'\n'
        loop=$(echo "${loop[*]}" | sort -nr | head -n1)

        if [  -L "/dev/mapper/loop${loop}p2" ] ; then
                mount /dev/mapper/loop${loop}p2 $ROOTFS
                mount /dev/mapper/loop${loop}p1 $BOOTFS

                echo "2 partition found"
        else
                echo "1 partition found"
                mount /dev/mapper/loop${loop}p1 $ROOTFS
        fi



        # mount binds
        mount --bind /dev $ROOTFS/dev/
        #mount --bind /dev $ROOTFS/dev/pts
        mount --bind /sys $ROOTFS/sys/
        mount --bind /proc $ROOTFS/proc/
        log "Image mounted"
}



umount_image() {
        IMAGE=$1
        BOOTFS=$2
        ROOTFS=$3

        umount $ROOTFS/dev/
        umount  $ROOTFS/sys/
        umount $ROOTFS/proc/
        #  umount $ROOTFS/dev/pts
        umount $BOOTFS
        umount $ROOTFS
        kpartx -d $IMAGE
        log "Image UNmounted"
}

downloadDietpiImgFor () {
        log " - Getting the DietPi image for $1"
        thisSbc=$1
        debianVersion=$2

        mkdir -p ./cache/$thisSbc

        if [ ! -f ./cache/$thisSbc/DietPi_$thisSbc-$debianVersion.img ]; then
                log " - - Downloading ..."
                wget -P ./cache/$thisSbc/  https://dietpi.com/downloads/images/DietPi_$thisSbc-$debianVersion.7z
                7z e  -o./cache/$thisSbc/ ./cache/$thisSbc/DietPi_$thisSbc-$debianVersion.7z
                rm ./cache/$thisSbc/DietPi_$thisSbc-$debianVersion.7z ./cache/$thisSbc/hash.txt ./cache/$thisSbc/README.txt

        else
                log " - - Using image from cache"

        fi

        log " - DONE Getting the DietPi image for $1"
}
