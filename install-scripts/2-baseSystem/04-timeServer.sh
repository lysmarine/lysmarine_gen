#!/bin/bash -e

apt-get install -y -q chrony
systemctl disable systemd-timesyncd
