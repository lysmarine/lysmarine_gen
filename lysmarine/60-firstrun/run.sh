#!/bin/bash

install -d     /etc/systemd/system
install -m 644 $FILE_FOLDER/firstRun.service "/etc/systemd/system/firstRun.service"
install -m 755 $FILE_FOLDER/firstrun "/usr/bin/firstrun"

systemctl enable firstRun.service ;

echo "mv /opt/freeboard-sk-linux-$arch /opt/freeboard-sk" >> /usr/bin/firstrun
echo "mv /opt/pypilot-webapp-linux-$arch /opt/pypilot-webapp" >> /usr/bin/firstrun
echo "mv /opt/signal-k-linux-$arch /opt/signal-k" >> /usr/bin/firstrun
echo "mv /opt/speed-sample-linux-$arch /opt/speed-sample">> /usr/bin/firstrun
