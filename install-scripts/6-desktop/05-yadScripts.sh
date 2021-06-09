#!/bin/bash -e

apt-get install -y -q yad ssh-askpass-gnome

install -d '/usr/local/share/applications'
install -m 755 $FILE_FOLDER/servicedialog.sh "/usr/local/bin/servicedialog"
install -m 644 $FILE_FOLDER/servicedialog.desktop "/usr/local/share/applications/"