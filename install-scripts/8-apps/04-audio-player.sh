#!/bin/bash -e

apt-get -y -q install audacious

# For bluetooth audio skipping
sed -i 's/921600/460800/' /usr/bin/btuart || true
