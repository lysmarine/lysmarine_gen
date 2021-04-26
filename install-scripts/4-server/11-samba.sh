#!/bin/bash -e

echo "samba-common samba-common/workgroup string WORKGROUP" | sudo debconf-set-selections
echo "samba-common samba-common/dhcp boolean true" | sudo debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true" | sudo debconf-set-selections

apt-get -y -q install samba samba-common samba-client

# systemctl enable smbd

install -m 755 -d -o root -g adm "/var/log/samba"
#install -m 755 -d -o root -g adm "/var/log/samba/cores"
