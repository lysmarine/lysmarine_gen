#!/bin/bash -e

apt-get install -y -q openssh-server

## If nothing specified (line commented), then forbid login as root
sed 's/^\#PermitRootLogin\ */PermitRootLogin\ no\ \#/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config

systemctl enable ssh
