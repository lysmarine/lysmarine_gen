#!/bin/bash -e
apt-get install -yy openssh-server
systemctl enable ssh
