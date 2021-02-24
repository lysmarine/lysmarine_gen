#!/bin/bash -e

# See: https://www.raspberrypi.org/forums/viewtopic.php?t=266101
# See also: https://github.com/spapadim/argon1

cd ~
mkdir argon1 && cd argon1
wget https://download.argon40.com/argon1.sh
chmod +x argon1.sh
sudo ./argon1.sh

echo "you should reboot now"
