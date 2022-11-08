#!/bin/bash -e
apt-get -yq install	simplelogin

install -v $FILE_FOLDER/simplelogin.service "/etc/systemd/system/"

cp /usr/bin/kwinwrapper /usr/local/bin/LMkwinwrapper
sed -i 's/\ --lockscreen//g' /usr/local/bin/LMkwinwrapper