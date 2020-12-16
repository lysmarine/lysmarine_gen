#!/bin/bash -e

apt-get install -y -q libc6

apt-get install -y -q kplex

install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/.kplex.conf "/home/user/.kplex.conf"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/kplex-lysmarine.conf "/etc/"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/kplex-lysmarine.conf "/etc/kplex.conf"

systemctl enable kplex
