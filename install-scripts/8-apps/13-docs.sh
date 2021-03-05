#!/bin/bash -e

install -d -o 1000 -g 1000 /home/user/Documents/

wget -q -O - https://bareboat-necessities.github.io/my-bareboat/bareboat-os.pdf > /home/user/Documents/bareboat-os.pdf
#wget -q -O - https://bareboat-necessities.github.io/my-bareboat/index.pdf > /home/user/Documents/my-bareboat.pdf
