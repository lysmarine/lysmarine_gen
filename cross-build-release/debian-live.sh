#!/bin/bash
source lib.sh
thisArch="debian-live"

checkRoot

setupWorkSpace $thisArch
pushd ./work/$thisArch
lb clean
popd

log "Add and build lysmarine mega script."
mkdir -p ./work/$thisArch/config/includes.chroot
mkdir -p ./work/$thisArch/config/hooks/live
cp -r ../install-scripts ./work/$thisArch/config/includes.chroot/install-scripts
install -d ./work/$thisArch/config/package-lists/
echo debian-installer-launcher >>./work/$thisArch/config/package-lists/my.list.chroot
#echo "d-i debian-installer/locale string en_US" \ >> config/includes.installer/preseed.cfg

cat <<EOT >./work/$thisArch/config/hooks/live/0060-build-lysmarine.hook.chroot
#!/bin/bash
    cd /install-scripts ;
    export LMBUILD=debian-64 ;
    find ./ -name run.sh  -exec chmod 775 {} \;
    chmod 0755 ./install.sh ;
    ./install.sh ;
    exit ;
EOT

mkdir -p ./work/$thisArch/config/hooks/live
mkdir -p ./work/$thisArch/config/bootloaders/isolinux
cp -r /usr/share/live/build/bootloaders/isolinux/* ./work/$thisArch/config/bootloaders/isolinux
cp -r ../install-scripts/2-baseSystem/files/background.svg ./work/$thisArch/config/bootloaders/isolinux/splash.svg
cat <<EOT >./work/$thisArch/config/bootloaders/isolinux/menu.cfg
menu hshift 0
menu width 82
menu title Lysmarine
include stdmenu.cfg
include live.cfg
menu clear
EOT

cat <<EOT >./work/$thisArch/config/bootloaders/isolinux/isolinux.cfg
include menu.cfg
default vesamenu.c32
prompt 0
timeout 3
EOT

pushd ./work/$thisArch
lb config noauto \
	--apt-indices false \
	--archive-areas "main contrib non-free" \
	--binary-images iso-hybrid \
	--clean \
	--debian-installer-gui true \
	--linux-package "linux-image linux-headers" \
	--bootloader syslinux \
	--distribution buster \
	--firmware-binary true \
	--grub-splash "/boot/grub/background.png" \
	--iso-application Lysmarine \
	--iso-publisher LysmarineOS \
	--linux-flavours amd64 \
	--memtest none \
	--mode debian \
	--security false \
	--system "live" \
	--verbose \
	--win32-loader true \
	--debian-installer live
echo debian-installer-launcher >>config/package-lists/my.list.chroot
#debian-installer-launcher
#https://live-team.pages.debian.net/live-manual/html/live-manual/customizing-installer.en.html

# --bootappend-live "boot=live splash quiet  hostname=lysmarine username=user sudo noeject" \

log "Start lb ..."
lb build

popd

mv ./work/$thisArch/live-image-amd64.hybrid.iso ./release/LysMarine_$thisArch-0.9.0.iso
log "DONE."

log "Pro Tip:"
echo ""
echo "iso file is located at ./release/LysMarine_$thisArch-0.9.0.iso "
echo ""

exit
