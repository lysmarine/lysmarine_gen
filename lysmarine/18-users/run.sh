#!/bin/bash -e
apt-get -y -q install sudo policykit-1

echo 'root:changeme' | chpasswd

oldUser=$(cat /etc/passwd | grep 1000:1000 | cut -f1 -d:) 

if [[ ! -z $oldUser ]]; then 
	userdel -r -f $oldUser
fi

if [[ -f /etc/sudoers.d/010_pi-nopasswd ]]; then
	rm /etc/sudoers.d/010_pi-nopasswd
fi

adduser --uid 1000 --home /home/user --quiet --disabled-password -gecos "lysmarine" user
echo 'user:changeme' | chpasswd

echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers

if [[ -d /etc/polkit-1 ]]; then
	install -v $FILE_FOLDER/all_all_users_to_shutdown_reboot.pkla "/etc/polkit-1/localauthority/50-local.d/"
	install -d "/etc/polkit-1/localauthority/10-vendor.d"
	install -v $FILE_FOLDER/org.freedesktop.NetworkManager.pkla  "/etc/polkit-1/localauthority/10-vendor.d/"
fi

usermod -a -G netdev user
usermod -a -G tty user
usermod -a -G sudo user

echo 'PATH="/sbin:/usr/sbin:$PATH"' >> /home/user/.profile

if [ $LMBUILD == armbian-pineA64 ] ;then
	rm /root/.not_logged_in_yet
fi

sed -i 's/^DESKTOP=/#&/'     /etc/xdg/user-dirs.defaults; 
sed -i 's/^TEMPLATES=/#&/'   /etc/xdg/user-dirs.defaults; 
sed -i 's/^PUBLICSHARE=/#&/' /etc/xdg/user-dirs.defaults; 
sed -i 's/^MUSIC=/#&/'       /etc/xdg/user-dirs.defaults; 
sed -i 's/^PICTURES=/#&/'    /etc/xdg/user-dirs.defaults; 
sed -i 's/^VIDEOS=/#&/'      /etc/xdg/user-dirs.defaults; 