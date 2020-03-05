#!/bin/bash
source lib.sh
thisArch="debian-live"



checkRoot ;



setupWorkSpace $thisArch ;
mkdir -p ./work/$thisArch/config/
cp -r ../lysmarine ./work/$thisArch/config/includes.chroot
cp -r ../lysmarine ./work/$thisArch/config/includes.bootstrap

mkdir -p ./work/$thisArch/config/hooks/live
echo "#!/bin/bash" >  ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
echo "cd /lysmarine"   >> ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
echo "export LMBUILD=debian-64"   >> ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
echo "find ./ -name run.sh  -exec chmod 775 {} \;"   >> ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
echo "ls -lah ./;"   >> ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
echo "chmod 0755 ./build.sh"     >> ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
echo "./build.sh"     >> ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
echo "exit"     >> ./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot


pushd ./work/$thisArch
    lb config noauto --archive-areas "main contrib non-free" --memtest none --distribution buster
    lb build
popd



mv ./work/$thisArch/*.iso ./release/$thisArch/

exit
log "DONE."



log "Pro Tip:"
echo ""
echo "sudo cp -v ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ./cache/$thisArch/$imageName-inflated"
echo ""
echo "sudo dd of=/dev/mmcblk0 if=./release/$thisArch/LysMarine_$thisArch-0.9.0.img status=progress"
echo ""

exit
