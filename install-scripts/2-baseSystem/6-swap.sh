#!/bin/bash -e
if [ -f /etc/dphys-swapfile ]; then
	sed -i "s/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1000/" /etc/dphys-swapfile
fi