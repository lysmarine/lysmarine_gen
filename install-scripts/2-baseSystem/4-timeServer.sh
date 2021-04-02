#!/bin/bash -e

## Use chrony as it's mor suited for inconsistent connections.
apt-get install -y -q chrony

systemctl disable systemd-timesyncd
