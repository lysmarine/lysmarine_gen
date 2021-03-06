#!/bin/bash -e

echo "I agree to Navionics Terms and Conditions viewable at https://www.navionics.com/usa/legal/terms-of-use"
read -r -p "Accept? [Y/n] " input

case $input in
 [yY][eE][sS]|[yY])
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
    Keywords=GPS;Navigation;Chart;
EOF';;
 [nN][oO]|[nN])
    echo "Exit"
    ;;
 *)
    echo "Exit"
    exit 1
    ;;
esac


