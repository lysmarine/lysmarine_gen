#!/bin/bash
if [ $LMOS == Raspbian ] ;then
	apt-get install -y -q chromium-browser
else
	apt-get install -y -q chromium
fi

apt-get install -y -q pcmanfm lxterminal mousepad gpsbabel file-roller
