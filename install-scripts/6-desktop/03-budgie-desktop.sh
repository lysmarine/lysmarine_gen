#!/bin/bash -e

apt-get install -y -q libatk-adaptor libgtk2.0-0

apt-get install -y -q libatk1.0-0 libcairo2 libfontconfig1 libfreetype6 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk2.0-0 \
  libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 librsvg2-common libx11-6

apt-get install -y -q menulibre

#apt-get install -y -q fbpanel

apt-get install -y -q gvfs-fuse gvfs-backends

install -o 1000 -g 1000 -d /home/user/.config/openbox
echo 'chromium --headless &' >>/home/user/.config/openbox/autostart

## Start budgie-desktop on openbox boot.
echo 'export XDG_CURRENT_DESKTOP=Budgie:GNOME; budgie-desktop &' >>/home/user/.config/openbox/autostart

apt-get clean

chmod 4775 /usr/bin/nm-connection-editor
#chmod 4775 /usr/bin/gnome-control-center
