#!/bin/bash

isEnabled () {
   res="$(systemctl is-enabled $1)"
   if [[ $res == "enabled" ]]; then
      echo "TRUE $1"
   else 
      echo "FALSE $1"
   fi
}

takeAction1 () {
  if echo "$1" | grep -q "$2"; then
    echo "=== enable $2 ==="
    sudo -A systemctl enable $2
    sudo -A systemctl start $2
  else
    echo "=== disable $2 ==="
    sudo -A systemctl disable $2
    sudo -A systemctl stop $2
  fi
}

takeAction2 () {
  if echo "$1" | grep -q "$2"; then
    echo "=== enable $2 ==="
    sudo -A systemctl enable $2
    sudo -A systemctl daemon-reexec
  else
    echo "=== disable $2 ==="
    sudo -A systemctl disable $2
    sudo -A systemctl daemon-reexec
  fi
}

takeAction3 () {
  if echo "$1" | grep -q "$2"; then
    echo "=== enable $2 ==="
    sudo -A systemctl enable $2
    sudo -A systemctl start $2
    sudo -A systemctl daemon-reload
  else
    echo "=== disable $2 ==="
    sudo -A systemctl disable $2
    sudo -A systemctl stop $2
    sudo -A systemctl daemon-reload
  fi
}

## List services and their status
rows="\
$(isEnabled NetworkManager) \
$(isEnabled create_ap) \
$(isEnabled ssh) \
$(isEnabled kplex) \
$(isEnabled pypilot@pypilot.service) \
$(isEnabled pypilot_web) \
$(isEnabled rtl-ais) \
$(isEnabled signalk) \
$(isEnabled vnc) \
$(isEnabled xrdp) \
$(isEnabled avnav) \
$(isEnabled mopidy) \
$(isEnabled pigpiod) \
"

## Dialog
save=$(
  yad --list \
  --height=400 \
  --text="Lysmarine has multiple services available. Enable and disable them based on what you need." \
  --column="Enable" \
  --column="Service" \
  --checklist \
  $rows
)

ret=$?
## Quit if cancel or close button has been pressed
[[ $ret -ne 0 ]] && exit 0

export SUDO_ASKPASS="/usr/bin/ssh-askpass"

takeAction1 "$save" NetworkManager
takeAction1 "$save" create_ap
takeAction1 "$save" ssh
takeAction1 "$save" kplex
takeAction1 "$save" pypilot@pypilot.service
takeAction1 "$save" pypilot_web
takeAction1 "$save" rtl-ais
takeAction1 "$save" signalk
takeAction1 "$save" vnc
takeAction1 "$save" xrdp
takeAction2 "$save" avnav
takeAction3 "$save" mopidy
takeAction1 "$save" pigpiod

