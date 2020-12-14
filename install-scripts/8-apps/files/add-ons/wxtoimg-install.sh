#!/bin/bash -e

# See: https://wxtoimgrestored.xyz

cd ~
curl https://wxtoimgrestored.xyz/beta/wxtoimg-armhf-2.11.2-beta.deb > wxtoimg-armhf-2.11.2-beta.deb

sudo apt install libxft2:armhf libasound2:armhf

sudo dpkg -i wxtoimg-armhf-2.11.2-beta.deb
