#!/bin/bash -e

apt-get clean

install -v -m 0644 $FILE_FOLDER/50-rtl-sdr.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/52-airspy.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/52-airspyhf.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/53-hackrf.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/66-mirics.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/88-nuand-bladerf1.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/88-nuand-bladerf2.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/88-nuand-bootloader.rules "/etc/udev/rules.d/"
#install -v -m 0644 $FILE_FOLDER/99-com.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/99-direwolf-cmedia.rules "/etc/udev/rules.d/"
install -v -m 0644 $FILE_FOLDER/99-thumbdv.rules "/etc/udev/rules.d/"

apt-get -y -q install multimon-ng netcat\
  cubicsdr                              \
  cutesdr                               \
  fldigi                                \
  gpredict                              \
  previsat                              \
  rtl-sdr rtl-ais                       \
  gnss-sdr                              \
  gnuradio                              \
  gnuais                                \
  gnuaisgui                             \
  dos2unix                              \
  gqrx-sdr                              \
  soapysdr-tools                        \
  hackrf                                \
  osmo-sdr                              \
  airspy                                \
  sox                                   \
  soundmodem                            \
  morse2ascii                           \
  w-scan                                \
  dvb-tools                             \
  dvb-apps                              \
  dtv-scan-tables                       \
  gr-dab                                \
  aprx                                  \
  wmctrl                                \
  rtl-sdr                               \
  librxtx-java                          \
  direwolf

# TODO:
#  dl-fldigi                             \
#  ssdv                                  \
#  chirp-daily                           \
#  hamfax                                \

install -d /usr/local/share/applications
install -d -m 755 -o 1000 -g 1000 "/home/user/.local/share/applications/"
install -d -m 755 -o 1000 -g 1000 "/home/user/.config/gqrx/"
install -v $FILE_FOLDER/gqrx-default.conf -o 1000 -g 1000 "/home/user/.config/gqrx/default.conf"
install -v $FILE_FOLDER/gqrx-bookmarks.csv -o 1000 -g 1000 "/home/user/.config/gqrx/bookmarks.csv"

systemctl disable direwolf
install -v $FILE_FOLDER/direwolf.conf -o 1000 -g 1000 "/home/user/"

systemctl disable aprx

install -d -m 755 "/usr/local/share/noaa-apt"
install -d -m 755 "/usr/local/share/noaa-apt/res"
install -d -m 755 "/usr/local/share/noaa-apt/res/shapefiles"
install -v $FILE_FOLDER/noaa-apt.desktop -o 1000 -g 1000 "/home/user/.local/share/applications/ar.com.mbernardi.noaa-apt.desktop"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/icon.png > "/usr/local/share/noaa-apt/res/icon.png"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/shapefiles/countries.shp > "/usr/local/share/noaa-apt/res/shapefiles/countries.shp"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/shapefiles/lakes.shp > "/usr/local/share/noaa-apt/res/shapefiles/lakes.shp"
wget -q -O - https://github.com/martinber/noaa-apt/raw/master/res/shapefiles/states.shp > "/usr/local/share/noaa-apt/res/shapefiles/states.shp"
if [ $LMARCH == 'arm64' ]; then
  apt-get -y -q install noaa-apt
fi
if [ $LMARCH == 'armhf' ]; then
  pushd /usr/local/share/noaa-apt
    wget -q -O - https://github.com/martinber/noaa-apt/releases/download/v1.3.0/noaa-apt-1.3.0-armv7-linux-gnueabihf.zip > noaa-apt.zip
    unzip -n noaa-apt.zip
    rm noaa-apt.zip
    chmod 755 noaa-apt
    mv noaa-apt /usr/bin/
  popd
fi

install -v $FILE_FOLDER/gnuaisgui.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/previsat.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/hamfax.desktop -o 1000 -g 1000 "/home/user/.local/share/applications/hamfax.desktop"

pip3 install pyrtlsdr wheel

# quisk
apt-get -y -q --no-install-recommends --no-install-suggests install python3-wxgtk4.0 \
    libfftw3-dev                       \
    libasound2-dev                     \
    portaudio19-dev                    \
    libpulse-dev                       \
    python3-dev                        \
    libpython3-dev                     \
    python3-usb                        \
    python3-wheel                      \
    python3-setuptools                 \
    python3-pip

pip3 install --upgrade quisk
install -v $FILE_FOLDER/quisk.desktop /usr/local/share/applications/
rm -rf ~/.cache/pip
# To run quisk
# python3 -m quisk


install -v $FILE_FOLDER/jnx.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/jwx.desktop /usr/local/share/applications/

install -d -m 755 "/usr/local/share/jnx"
install -d -m 755 "/usr/local/share/jwx"

wget -q -O - https://arachnoid.com/JNX/JNX.jar > /usr/local/share/jnx/JNX.jar
wget -q -O - https://arachnoid.com/JNX/JNX_source.tar.gz > /usr/local/share/jnx/JNX_source.tar.gz

wget -q -O - https://arachnoid.com/JWX/resources/JWX.jar > /usr/local/share/jwx/JWX.jar
wget -q -O - https://arachnoid.com/JWX/resources/JWX_source.tar.bz2 > /usr/local/share/jwx/JWX_source.tar.bz2

apt-get -y -q install fontconfig
if [ $LMARCH == 'armhf' ]; then
  apt-get -y -q install openjdk-8-jdk
else
  apt-get -y -q install default-jdk
fi

apt-get clean

#####################################################################################################
# YAAC https://www.ka2ddo.org/ka2ddo/YAAC.html

MY_DIR_OLD=$(pwd)
cd /home/user

wget https://www.ka2ddo.org/ka2ddo/YAAC.zip
mkdir YAAC && cd YAAC
unzip ../YAAC.zip

bash -c 'cat << EOF > /usr/local/share/applications/YAAC.desktop
[Desktop Entry]
Type=Application
Name=YAAC
GenericName=YAAC
Comment=YAAC
Exec=sh -c "cd /home/user/YAAC; java -jar YAAC.jar"
Terminal=false
Icon=radio
Categories=HamRadio;Radio;Weather
Keywords=HamRadio;Radio;Weather
EOF'

cd "$MY_DIR_OLD"
rm -rf ~/.wget*

#####################################################################################################
# Inmarsat
# See: https://bitbucket.org/scytalec/scytalec/src/develop/

#apt-get -y install mono-complete

MY_DIR_OLD=$(pwd)
cd /home/user

mkdir scytalec-inmarsat-bin && cd scytalec-inmarsat-bin

echo -n "Install MONO like this:" > readme-first.txt
echo -n "sudo apt-get -y install mono-complete dos2unix" >> readme-first.txt

wget https://bitbucket.org/scytalec/scytalec/downloads/content-info.txt
wget https://bitbucket.org/scytalec/scytalec/downloads/SDRSharp.ScytaleC.5001.NET5.PlusUI.zip
wget https://bitbucket.org/scytalec/scytalec/downloads/x64-ScytaleC.QuickUI-17010.zip
wget https://bitbucket.org/scytalec/scytalec/downloads/x64-FramePlayer-1002Beta.zip
wget https://bitbucket.org/scytalec/scytalec/downloads/x64-SDRSharp.ScytaleC-10213.zip
wget https://bitbucket.org/scytalec/scytalec/downloads/x64-ScytaleC-1403.zip
wget https://bitbucket.org/scytalec/scytalec/downloads/x64-DebugHelpers.zip
wget https://bitbucket.org/scytalec/scytalec.decoder/downloads/x64_Scytalec.Decoder.UI_1.0.0.1.zip
wget https://bitbucket.org/scytalec/scytalec.decoder/downloads/x64_Scytalec.Decoder.Cmd_1.0.zip

dos2unix content-info.txt

mkdir ScytaleC
cd ScytaleC/
unzip ../x64-ScytaleC-1403.zip
chmod +x ./*.exe
cd ..

mkdir ScytaleC-UI
cd ScytaleC-UI
unzip ../x64-ScytaleC.QuickUI-17010.zip
chmod +x ./*.exe
cd ..

mkdir ScytaleC-dec
cd ScytaleC-dec
unzip ../x64_Scytalec.Decoder.Cmd_1.0.zip
chmod +x ./*.exe
cd ..

mkdir ScytaleC-dec-UI
cd ScytaleC-dec-UI
unzip ../x64_Scytalec.Decoder.UI_1.0.0.1.zip
chmod +x ./*.exe
cd ..

cd "$MY_DIR_OLD"
rm -rf ~/.wget*

bash -c 'cat << EOF > /usr/local/share/applications/scytaleC-decoder.desktop
[Desktop Entry]
Type=Application
Name=Scytale-C Inmarsat Decoder
GenericName=Scytale-C Inmarsat Decoder
Comment=Scytale-C Inmarsat Decoder
Exec=/home/user/scytalec-inmarsat-bin/ScytaleC-dec-UI/ScytaleC.Decoder.UI.exe
Terminal=false
Icon=ModemManager
Categories=Hamradio
Keywords=Hamradio
EOF'

bash -c 'cat << EOF > /usr/local/share/applications/scytaleC.desktop
[Desktop Entry]
Type=Application
Name=Scytale-C Inmarsat
GenericName=Scytale-C Inmarsat
Comment=Scytale-C Inmarsat UI
Exec=/home/user/scytalec-inmarsat-bin/ScytaleC/ScytaleC.exe
Terminal=false
Icon=ModemManager
Categories=Hamradio
Keywords=Hamradio
EOF'


#################################

apt-get install -y cmake

pushd /usr/local/share
  git clone https://github.com/bareboat-necessities/aisdecoder
  cd aisdecoder
  mkdir build && cd build
  # Moving to first-run due to this bug: https://gitlab.kitware.com/cmake/cmake/-/issues/20568
  # cmake ../ -DCMAKE_BUILD_TYPE=RELEASE
  # make
  # cp aisdecoder /usr/local/bin/
  cd ../..
popd
