#! /bin/bash
{
if [[ $2 == "remove" ]] ; then
	logger "The USB device $1 have been disconnected" ;
	systemctl stop lysgpsd@$1.service ;

else
	logger "This USB device is known as a GPS and will be connected to gpsd on port 2947"$1 ;
	systemctl restart lysgpsd@$1.service ;
	sleep 1 ;
	systemctl restart signalk ;

fi
}&
