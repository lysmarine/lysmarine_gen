#!/bin/bash -e

apt-get clean

apt-get -y -q install multimon-ng netcat
apt-get -y -q install cubicsdr
apt-get -y -q install fldigi
apt-get -y -q install gpredict
apt-get -y -q install previsat
apt-get -y -q install gqrx-sdr
apt-get -y -q install rtl-sdr rtl-ais
apt-get -y -q install gnss-sdr
apt-get -y -q install gnuradio
apt-get -y -q install gnuais
apt-get -y -q install gnuaisgui
apt-get -y -q install noaa-apt

install -v $FILE_FOLDER/gnuaisgui.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/previsat.desktop /usr/local/share/applications/

# quisk
apt-get -y -q install python3-wxgtk4.0 \
    libfftw3-dev                       \
    libasound2-dev                     \
    portaudio19-dev                    \
    libpulse-dev                       \
    python3-dev                        \
    libpython3-dev                     \
    python3-usb                        \
    python3-setuptools                 \
    python3-pip
python3 -m pip install --upgrade quisk
# To run quisk
# python3 -m quisk



install -v $FILE_FOLDER/jnx.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/jwx.desktop /usr/local/share/applications/

install -d -m 755 "/usr/local/share/jnx"
install -d -m 755 "/usr/local/share/jwx"

curl https://arachnoid.com/JNX/JNX.jar > /usr/local/share/jnx/JNX.jar
curl https://arachnoid.com/JNX/JNX_source.tar.gz > /usr/local/share/jnx/JNX_source.tar.gz

curl https://arachnoid.com/JWX/resources/JWX.jar > /usr/local/share/jwx/JWX.jar
curl https://arachnoid.com/JWX/resources/JWX_source.tar.bz2 > /usr/local/share/jwx/JWX_source.tar.bz2

apt-get -y -q install default-jdk
apt-get -y -q install hamfax

apt-get clean
