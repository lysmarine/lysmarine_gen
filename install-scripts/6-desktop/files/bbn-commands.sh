#!/bin/bash

action=$(yad --title "System Actions" --width=500 --height=300  --text-align=center --text "\n" --list --no-headers --dclick-action=none --print-column=1 --column "Choice":HD --column "Action" reboot Reboot shutdown Shutdown restartD "Restart Desktop" restartSK "Restart SignalK")

ret=$?

[[ $ret -eq 1 ]] && exit 0

case $action in
    reboot*) cmd="/sbin/reboot" ;;
    shutdown*) cmd="/sbin/poweroff" ;;
    restartD*) cmd="budgie-panel --replace&" ;;
    restartSK*) cmd="/usr/local/bin/signalk-restart" ;;
    *) exit 1 ;;
esac

eval exec $cmd
