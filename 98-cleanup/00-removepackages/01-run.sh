#!/bin/bash -e


on_chroot << EOF
apt remove -y xterm
EOF
