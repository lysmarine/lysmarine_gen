#!/bin/bash -e

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"

if [[ $LMARCH == 'arm64' ]] ;then
	apt-mark hold opencpn
	apt-get install -y -q build-essential cmake gettext git-core gpsd gpsd-clients libgps-dev wx-common libwxgtk3.0-dev libglu1-mesa-dev libgtk2.0-dev wx3.0-headers libbz2-dev libtinyxml-dev libportaudio2 portaudio19-dev libcurl4-openssl-dev libexpat1-dev libcairo2-dev libarchive-dev liblzma-dev libexif-dev libelf-dev libsqlite3-dev
	
	pushd ./stageCache 
		if [[ ! -f opencpn-data_5.0.0+dfsg-1_all.deb ]]; then 
			wget http://http.us.debian.org/debian/pool/main/o/opencpn/opencpn-data_5.0.0+dfsg-1_all.deb
		fi
		dpkg -i opencpn-data_5.0.0+dfsg-1_all.deb # This ugly workaround bypass : https://github.com/OpenCPN/OpenCPN/issues/1685 and https://github.com/OpenCPN/OpenCPN/issues/1712
	

		if [[ ! -f OpenCPN ]]; then 
			git clone --depth 1 git://github.com/OpenCPN/OpenCPN.git
			mkdir -p ./OpenCPN/build

			pushd ./OpenCPN/build;
				cmake -DOCPN_BUNDLE_TCDATA=ON -DOCPN_BUNDLE_GSHHS=CRUDE ../
				make
			popd
		fi
	pushd ./OpenCPN/build;
		make install
	popd
	#sed -i 's/\/usr\/share\//\/usr\/local\/share\//' "/home/user/.opencpn/opencpn.conf"
	popd

else
	apt-get install -y -q opencpn

fi
