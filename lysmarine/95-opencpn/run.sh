#!/bin/bash -e

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"


if [ $LMBUILD == armbian-pineA64 ] ;then
	apt-get install -y -q build-essential cmake gettext git-core gpsd gpsd-clients libgps-dev wx-common libwxgtk3.0-dev libglu1-mesa-dev libgtk2.0-dev wx3.0-headers libbz2-dev libtinyxml-dev libportaudio2 portaudio19-dev libcurl4-openssl-dev libexpat1-dev libcairo2-dev libarchive-dev liblzma-dev libexif-dev libelf-dev libsqlite3-dev
	git clone git://github.com/OpenCPN/OpenCPN.git
	mkdir -p ./OpenCPN/build

	pushd ./OpenCPN/build;
		cmake -DCFLAGS="-O2 -march=native" -DBUNDLE_DOCS=OFF -DBUNDLE_TCDATA=ON -DBUNDLE_GSHHS=HIGH ../
		make
		make install
	popd
	rm -r ./OpenCPN

	apt-get download opencpn-tcdata
	dpkg -i --ignore-depends=opencpn opencpn-tcdata*
	apt download opencpn-gshhs-*
	dpkg -i --ignore-depends=opencpn opencpn-gshhs-*

	rm opencpn-tcdata* opencpn-gshhs-*
else
	apt-get install -y -q opencpn

fi
