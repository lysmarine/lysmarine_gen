#!/bin/bash
## https://pysselilivet.blogspot.com/2018/06/ais-reciever-for-raspberry.html
apt-get install -yq rtl-ais
apt-get install -yq kalibrate-rtl || true

## Set default state.
systemctl disable rtl-ais