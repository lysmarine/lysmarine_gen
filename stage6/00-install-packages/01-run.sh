#!/bin/bash -e

on_chroot << EOF
  pip install paho-mqtt geomag spydev;
EOF
