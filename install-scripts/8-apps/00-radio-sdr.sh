#!/bin/bash -e

apt-get clean

apt-get -y -q install rtl-sdr rtl-ais
apt-get -y -q install cubicsdr
apt-get -y -q install multimon-ng netcat
apt-get -y -q install fldigi
apt-get -y -q install gpredict
apt-get -y -q install gqrx-sdr
apt-get -y -q install previsat
apt-get -y -q install gnss-sdr

apt-get clean
