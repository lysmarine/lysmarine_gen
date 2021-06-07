#!/bin/bash -e

apt-get install -y -q libc6 kplex

install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/kplex-lysmarine.conf "/etc/"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/kplex-lysmarine.conf "/etc/kplex.conf"

systemctl disable kplex
