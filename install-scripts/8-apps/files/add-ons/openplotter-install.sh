#!/bin/bash -e

echo "OpenPlotter is not known to support this OS. If you are a tester"
echo "and willing to report issues to OpenPlotter hit 'Y', otherwise hit 'N'"
read -r -p "Continue ? [Y/n] " input
 
case $input in
 [yY][eE][sS]|[yY])
    sudo apt install $(apt-cache search openplotter- | cut -d ' ' -f 1 | grep -v pypilot)
    ;;
 [nN][oO]|[nN])
    echo "Exit"
    ;;
 *)
    echo "Exit"
    exit 1
    ;;
esac
