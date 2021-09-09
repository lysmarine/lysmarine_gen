#!/bin/bash

action=$(yad --title "System Actions" --width=500 --height=300  --text-align=center --text "\n" --list --no-headers --dclick-action=none --print-column=1 --column "Choice":HD --column "Action" reboot Reboot shutdown Shutdown restartD "Restart Desktop" restartPyP "Restart PyPilot" restartSK "Restart SignalK" restartAvN "Restart AvNav")

ret=$?

[[ $ret -eq 1 ]] && exit 0

case $action in
    reboot*) cmd='sh -c "kill $(pidof opencpn); sleep 4; /sbin/reboot"' ;;
    shutdown*) cmd='sh -c "kill $(pidof opencpn); sleep 4; /sbin/poweroff"' ;;
    restartD*) cmd="budgie-panel --replace&" ;;
    restartPyP*) cmd="sudo /usr/local/sbin/pypilot-restart" ;;
    restartSK*) cmd="sudo /usr/local/sbin/signalk-restart" ;;
    restartAvN*) cmd="sudo /usr/local/sbin/avnav-restart" ;;
    *) exit 1 ;;
esac

eval exec $cmd
