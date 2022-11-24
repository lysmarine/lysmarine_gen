#!/bin/bash -e
## Apps
apt-get -yq install \
	kgx \
	gpsbabel \
	nautic \
	chromium \
	elisa \
	kalk \
	index

## Rpi specific packages
apt-get install -yq --no-install-recommends piclone pigpio libturbojpeg0 raspi-copies-and-fills || true
apt-get install -yq rpi-chromium-mods || apt-get install -yq chromium-sandbox

## remove extra packages
apt-get purge --auto-remove -yq system-config-printer # chromium install cups but we don't need it.
