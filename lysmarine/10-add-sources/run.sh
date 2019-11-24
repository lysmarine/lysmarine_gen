#!/bin/bash -e
apt update -yy && apt upgrade -yy
apt-get install -y cmake build-essential curl dirmngr apt-transport-https lsb-release git

# Nodejs10
wget wget -q -O- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add
DISTRO="$(lsb_release -s -c)"
echo "deb https://deb.nodesource.com/node_10.x $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list

# Opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220
cp $FILE_FOLDER/opencpnsource.list /etc/apt/sources.list.d/opencpnsource.list

# Upadate
apt update  -yy
