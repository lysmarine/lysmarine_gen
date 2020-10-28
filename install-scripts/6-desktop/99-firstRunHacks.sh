#!/bin/bash

install -d -m 755 "/etc/systemd/system"
install    -m 644 $FILE_FOLDER/firstRun.service "/etc/systemd/system/firstRun.service"
install -d -m 755 "/usr/local/sbin"
install    -m 755 $FILE_FOLDER/firstrun "/usr/local/sbin/firstrun"

systemctl enable firstRun.service
