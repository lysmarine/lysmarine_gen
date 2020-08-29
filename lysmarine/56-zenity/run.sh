#!/bin/bash

apt-get install -y -q zenity ssh-askpass-gnome
install -d '/usr/local/share/applications'
install -m 755 $FILE_FOLDER/servicedialog "/usr/local/bin"
install -m 644 $FILE_FOLDER/servicedialog.desktop "/usr/local/share/applications/"