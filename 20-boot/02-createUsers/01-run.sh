#!/bin/bash -e


on_chroot << EOF
   useradd -d /var/www -G www-data
EOF
