#!/bin/bash -e

apt-get install -y -q libc6

install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/.kplex.conf "/home/user/.kplex.conf"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/kplex-lysmarine.conf "/etc/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/kplex-lysmarine.conf "/etc/kplex.conf"

apt-get install -y -q kplex

systemctl enable kplex
