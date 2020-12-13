#!/bin/bash -e

# See: https://www.meltemus.com

cd /home/user
curl https://www.meltemus.com/index.php/en/download/send/9-raspberrypi/281-qtvlm-5-9-14-p2-7 > qtVlm-5.9.14-p2-rpi.tar.gz
gzip -cd < qtVlm-5.9.14-p2-rpi.tar.gz | tar xvf -
curl https://raw.githubusercontent.com/bareboat-necessities/my-bareboat/master/qtvlm-conf/qtVlm.ini > /home/user/.qtVlm/qtVlm.ini

sudo bash -c 'cat << EOF > /usr/share/raspi-ui-overrides/applications/qtvlm.desktop
[Desktop Entry]
Type=Application
Name=QtVlm
GenericName=QtVlm
Comment=QtVlm ChartPlotter
Exec=sh -c "cd /home/user/qtVlm; ./qtVlm -platform xcb"
Terminal=false
Icon=/home/user/qtVlm/icon/qtVlm_48x48.png
Categories=Navigation;ChartPlotter
Keywords=Navigation;ChartPlotter
EOF'

# cd qtVlm
# ./qtVlm -platform xcb
