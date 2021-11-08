#!/bin/bash -e

# See: https://www.p4dragon.com/en/PMON.html

echo "deb https://www.scs-ptc.com/repo/packages/ bullseye non-free" | sudo tee /etc/apt/sources.list.d/scs.list > /dev/null
wget -q -O - https://www.scs-ptc.com/repo/packages/scs.gpg.key | sudo apt-key add -

sudo apt update
sudo apt-get -y install pmon

# running
# pmon

