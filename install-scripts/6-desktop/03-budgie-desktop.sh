#!/bin/bash -e

apt-get install -y -q libatk-adaptor libgtk-3-0 libatk1.0-0 libcairo2 libfontconfig1 libfreetype6 \
  libgdk-pixbuf2.0-0 libglib2.0-0  \
  libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 librsvg2-common libx11-6 menulibre \
  gvfs-fuse gvfs-backends gnome-bluetooth ibus openbox

install -o 1000 -g 1000 -d /home/user/.config/openbox

if [ $LMARCH == 'arm64' ]; then
  echo 'chromium --headless &' >>/home/user/.config/openbox/autostart
else
  echo 'chromium-browser --headless &' >>/home/user/.config/openbox/autostart
fi

## Start budgie-desktop on openbox boot.
echo 'export XDG_CURRENT_DESKTOP=Budgie:GNOME; budgie-desktop &' >>/home/user/.config/openbox/autostart

apt-get clean

chmod 4775 /usr/bin/nm-connection-editor
#chmod 4775 /usr/bin/gnome-control-center
