#!/bin/bash -e

apt-get install -y -q openssh-server

## If nothing is specified (line commented), forbid login as root
sed 's/^\#PermitRootLogin\ */PermitRootLogin\ no\ \#/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config

## Ssh us enabled by default as there is a possibility that lysmarine would be run headless.
systemctl enable ssh
