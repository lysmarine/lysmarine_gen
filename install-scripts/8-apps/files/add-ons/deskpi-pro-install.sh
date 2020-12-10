#!/bin/bash -e

# See: https://github.com/DeskPi-Team/deskpi

cd ~
git clone https://github.com/DeskPi-Team/deskpi.git
cd ~/deskpi/
chmod +x install.sh
sudo ./install.sh
