#!/bin/bash -e

## Base desktop Env
apt-get -yq	--no-install-recommends install plasma-phone-components plasma-phone-settings firmware-ti-connectivity-
apt-get -yq install	plasma-nm kde-config-mobile-networking plasma-settings polkit-kde-agent-1 kdeconnect-
apt-get -yq install plasma-pa
