#!/bin/bash -e

#change language
sed -i "s/XKBLAYOUT=.*/XKBLAYOUT=\"us\"/g" /etc/default/keyboard
#setxkbmap
