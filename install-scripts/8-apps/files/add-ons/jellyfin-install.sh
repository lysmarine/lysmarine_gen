#!/bin/bash -e

sudo apt install jellyfin

sudo systemctl enable jellyfin
sudo systemctl start jellyfin

# visit http://localhost:8096/
# to continue set up
