#! /bin/bash
{
  chmod a+r /dev/ttyLYS_ch340_"$1"
  if [[ $2 == "remove" ]] ; then
    logger "The USB device /dev/ttyLYS_ch340_$1 has been disconnected"
  else
    logger "This USB device is known as ch340 and will be linked on /dev/ttyLYS_ch340_$1"
    systemctl restart kplex.service
    sleep 1
    systemctl restart signalk
  fi
}&
