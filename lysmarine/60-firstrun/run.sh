#!/bin/bash

install -d     /etc/systemd/system
install -m 644 $FILE_FOLDER/firstRun.service "/etc/systemd/system/firstRun.service"
install -m 755 $FILE_FOLDER/firstrun "/usr/bin/firstrun"

systemctl enable firstRun.service ;
