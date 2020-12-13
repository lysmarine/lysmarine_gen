#!/bin/bash -e

# See: https://wxtoimgrestored.xyz

cd ~
curl https://wxtoimgrestored.xyz/beta/wxtoimg-armhf-2.11.2-beta.deb > wxtoimg-armhf-2.11.2-beta.deb
sudo dpkg -i wxtoimg-armhf-2.11.2-beta.deb
