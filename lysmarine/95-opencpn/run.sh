#!/bin/bash -e

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"


if [ $LMBUILD == armbian-pineA64 ] ;then
	apt-mark hold opencpn
	apt-get install -y -q build-essential cmake gettext git-core gpsd gpsd-clients libgps-dev wx-common libwxgtk3.0-dev libglu1-mesa-dev libgtk2.0-dev wx3.0-headers libbz2-dev libtinyxml-dev libportaudio2 portaudio19-dev libcurl4-openssl-dev libexpat1-dev libcairo2-dev libarchive-dev liblzma-dev libexif-dev libelf-dev libsqlite3-dev
	
	git clone --depth 1 git://github.com/OpenCPN/OpenCPN.git
	mkdir -p ./OpenCPN/build

	pushd ./OpenCPN/build;
		# cmake  -DOCPN_BUNDLE_TCDATA=ON -DOCPN_BUNDLE_GSHHS=FULL ../ #
		#sed -i 's/\/usr\/share\//\/usr\/local\/share\//' "/home/user/.opencpn/opencpn.conf"
		cmake ../
		make
		make install
	popd
	
	pushd ./OpenCPN
		apt-get download opencpn-tcdata
		apt-get download opencpn-gshhs-*
		apt-mark hold  opencpn-tcdata opencpn-gshhs-*
		dpkg -i --ignore-depends=opencpn opencpn-tcdata*
		dpkg -i --ignore-depends=opencpn opencpn-gshhs-*
	popd

	rm -r ./OpenCPN
else
	apt-get install -y -q opencpn

fi
