#!/bin/bash -e

on_chroot << EOF
  git clone https://github.com/oblique/create_ap
  cd create_ap
  make install
  cd /
  rm -rf create_ap
EOF
