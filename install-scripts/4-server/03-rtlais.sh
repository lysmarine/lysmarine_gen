#!/bin/bash
## https://pysselilivet.blogspot.com/2018/06/ais-reciever-for-raspberry.html

apt-get install -y -q rtl-ais kalibrate-rtl

## Adding service file
install -v -m 0644 $FILE_FOLDER/rtl-ais.service "/etc/systemd/system/"
systemctl disable rtl-ais.service
