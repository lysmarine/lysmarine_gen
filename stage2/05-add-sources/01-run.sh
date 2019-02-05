#!/bin/bash -e
on_chroot <<EOF

# opencpn
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67E4A52AC865EB40 ;
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF0E1940624A220 ;
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C865EB40 ;
echo "deb http://ppa.launchpad.net/opencpn/opencpn/ubuntu/ xenial main" >> /etc/apt/sources.list ;

# nodejs
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add ;


echo "deb https://deb.nodesource.com/node_8.x xenial main" > /etc/apt/sources.list.d/nodesource.list ;
echo "deb-src https://deb.nodesource.com/node_8.x xenial main" >> /etc/apt/sources.list.d/nodesource.list ;
apt update ;
EOF
