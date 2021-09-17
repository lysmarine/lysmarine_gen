#!/bin/bash -e

CUR_DIR="$(pwd)"

mkdir -p ~/Documents/ && cd ~/Documents/

wget "https://github.com/bareboat-necessities/maritime-lib/releases/download/v2021-09-17/maritime-lib.tar.xz"

xzcat maritime-lib.tar.xz | tar xvf -

rm maritime-lib.tar.xz

cd "$CUR_DIR"
