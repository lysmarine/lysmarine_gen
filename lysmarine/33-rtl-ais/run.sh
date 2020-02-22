#!/bin/bash
## https://pysselilivet.blogspot.com/2018/06/ais-reciever-for-raspberry.html
apt-get install -y -q git librtlsdr-dev



## Compiling 
git clone --depth 1 https://github.com/dgiardini/rtl-ais/
pushd ./rtl-ais
	sed -i "s/^LDFLAGS.*librtlsdr./LDFLAGS+=-lpthread\ -lm\ -lrtlsdr\ -L\ \/usr\/lib\/arm-linux-gnueabihf\//" Makefile
	make
	install -o root -g root -m 0755 ./rtl_ais "/usr/local/bin/"
popd
rm ./rtl-ais



## Adding service file 
install -v -m 0644 $FILE_FOLDER/rtl-ais.service "/etc/systemd/system/"
systemctl enable rtl-ais.service
