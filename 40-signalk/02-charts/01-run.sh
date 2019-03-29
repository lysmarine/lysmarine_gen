#!/bin/bash -e

on_chroot << EOF
   groupadd charts;
   usermod -a -G charts signalk;
   usermod -a -G charts pi;
   usermod -a -G charts root;
   mkdir -m 775 /srv/charts;
   chown signalk:charts /srv/charts;
   chmod ug+s /srv/charts;
   ln -s /srv/charts /home/pi/charts;
EOF
