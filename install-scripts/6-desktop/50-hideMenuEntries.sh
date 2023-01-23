#!/bin/bash -e
## Install service manager after every services it manage
apt-get install -yq servicemanager

echo "Hidden=true" >> /usr/share/applications/pcmanfm-desktop-pref.desktop
echo "Hidden=true" >> /usr/share/applications/vim.desktop
echo "Hidden=true" >> /usr/share/applications/PyCrust.desktop
echo "Hidden=true" >> /usr/share/applications/XRCed.desktop
echo "Hidden=true" >> /usr/share/applications/yad-icon-browser.desktop
echo "Hidden=true" >> /usr/share/applications/x11vnc.desktop
echo "Hidden=true" >> /usr/share/applications/org.gnome.FileRoller.desktop
echo "Hidden=true" >> /usr/share/applications/mopidy.desktop
echo "Hidden=true" >> /usr/share/applications/mlterm.desktop
echo "Hidden=true" >> /usr/share/applications/htop.desktop
echo "Hidden=true" >> /usr/share/applications/org.gnome.Firmware.desktop
echo "Hidden=true" >> /usr/share/applications/ibus-setup-m17n.desktop
echo "Hidden=true" >> /usr/share/applications/im-config.desktop
echo "Hidden=true" >> /usr/share/applications/org.freedesktop.IBus.Setup.desktop