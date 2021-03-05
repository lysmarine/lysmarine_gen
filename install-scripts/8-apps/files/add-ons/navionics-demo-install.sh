#!/bin/bash -e

sudo bash -c 'cat << EOF > /usr/local/share/applications/navionics-demo.desktop
[Desktop Entry]
Type=Application
Name=Navionics Demo
GenericName=Navionics Demo
Comment=Navionics Demo
Exec=chromium https://webapp.navionics.com/
Terminal=false
Icon=gnome-globe
Categories=System;GPS;Geography;Navigation;Chart;
Keywords=GPS;Navigation;Chart;'
