#!/bin/bash -e

## Force keyboard layout to be EN US by default.
sed -i "s/XKBLAYOUT=.*/XKBLAYOUT=\"us\"/g" /etc/default/keyboard

