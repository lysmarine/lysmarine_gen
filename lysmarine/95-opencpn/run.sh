#!/bin/bash -e

install -o 1000 -g 1000 -d "/home/dietpi/.opencpn"
install -o 1000 -g 1000  -v $FILE_FOLDER/opencpn.conf    "/home/dietpi/.opencpn/"

apt-get install -y \
ofc-pi \
opencpn  \
opencpn-plugin-otcurrent \
opencpn-plugin-chartdldr \
opencpn-plugin-statusbar \
opencpn-plugin-br24radar \
opencpn-plugin-gradar \
opencpn-plugin-dr \
opencpn-plugin-rtlsdr \
opencpn-plugin-s63 \
opencpn-plugin-iacfleet \
opencpn-plugin-vdr \
opencpn-plugin-launcher \
opencpn-plugin-aisradar \
opencpn-plugin-wmm \
opencpn-plugin-projections \
opencpn-plugin-weatherfax \
opencpn-plugin-rotationctrl \
opencpn-plugin-draw \
opencpn-plugin-polar \
opencpn-plugin-sweepplot \
opencpn-plugin-objsearch \
opencpn-plugin-pypilot \
opencpn-plugin-watchdog \
opencpn-plugin-route \
opencpn-plugin-logbookkonni \
opencpn-plugin-celestial \
opencpn-plugin-squiddio \
opencpn-plugin-weatherrouting
