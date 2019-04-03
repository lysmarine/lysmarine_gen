#!/bin/bash -e


on_chroot << EOF
   useradd -d /var/www -G www-data
   mkdir /var/www
   chown www-data:www-data /var/www
EOF
