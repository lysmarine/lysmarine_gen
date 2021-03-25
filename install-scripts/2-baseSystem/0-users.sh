#!/bin/bash -e
apt-get -y -q install sudo policykit-1

## Force keyboard layout to be EN US by default.
sed -i "s/XKBLAYOUT=.*/XKBLAYOUT=\"us\"/g" /etc/default/keyboard

## Set root password.
echo 'root:changeme' | chpasswd

## Remove default user (if any).
oldUser=$(cat /etc/passwd | grep 1000:1000 | cut -f1 -d:) 
if [[ ! -z $oldUser ]]; then 
	echo "Removing user "$oldUser
	userdel -r -f $oldUser
else
	echo "No default user found !"
fi

## Add default user.
adduser --uid 1000 --home /home/user --quiet --disabled-password -gecos "lysmarine" user
echo 'user:changeme' | chpasswd
echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers
usermod -a -G netdev,tty,sudo,video,input,plugdev user

## Create signalk user to run the server.
if [ ! -d /home/signalk ] ; then
	echo "Creating signalk user"
	adduser --home /home/signalk --gecos --system --disabled-password --disabled-login signalk
fi

## Create pypilot user to run the services.
if [ ! -d /home/pypilot ] ; then
	echo "Creating pypilot user"
	adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot
	usermod -a -G tty pypilot
	usermod -a -G i2c pypilot || true
	usermod -a -G spi pypilot || true
	usermod -a -G gpio pypilot || true
	usermod -a -G dialout pypilot || true
fi

## Create the charts group and add users that have to write to that folder.
if ! grep -q charts /etc/group ; then
	groupadd charts;
	usermod -a -G charts signalk;
	usermod -a -G charts user;
	usermod -a -G charts root;
fi

## Create the special charts folder.
install -v -d -m 6775 -o signalk -g charts /srv/charts; 

## Link the chart folder to home for convenience.
if [ ! -f /home/user/charts ] ; then
	su user -c "ln -s /srv/charts /home/user/charts;"
fi

## Manage the permissions and privileges.
if [[ -d /etc/polkit-1 ]]; then
	echo "polkit found, adding rules"
	install -v $FILE_FOLDER/all_all_users_to_shutdown_reboot.pkla "/etc/polkit-1/localauthority/50-local.d/"
	install -v $FILE_FOLDER/mount.pkla "/etc/polkit-1/localauthority/50-local.d/"
	install -d "/etc/polkit-1/localauthority/10-vendor.d"
	install -v $FILE_FOLDER/org.freedesktop.NetworkManager.pkla  "/etc/polkit-1/localauthority/10-vendor.d/"
fi

## Remove the raspbian no-pwd sudo to user pi.
if [[ -f /etc/sudoers.d/010_pi-nopasswd ]]; then
	rm /etc/sudoers.d/010_pi-nopasswd
fi

## Give user capability to halt and reboot.
echo 'PATH="/sbin:/usr/sbin:$PATH"' >> /home/user/.profile

if [ -f /root/.not_logged_in_yet ] ;then # Disable Armbian first login script.
	rm /root/.not_logged_in_yet
fi

## Prevent the creation of useless home folders on first boot.
if [ -f /etc/xdg/user-dirs.defaults ] ;then
  sed -i 's/^DESKTOP=/#&/'     /etc/xdg/user-dirs.defaults;
  sed -i 's/^TEMPLATES=/#&/'   /etc/xdg/user-dirs.defaults;
  sed -i 's/^PUBLICSHARE=/#&/' /etc/xdg/user-dirs.defaults;
fi
