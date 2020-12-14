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

install -v $FILE_FOLDER/gnuaisgui.desktop /usr/local/share/applications/

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

apt-get clean
