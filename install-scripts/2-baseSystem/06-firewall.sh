#!/bin/bash -e

apt-get -y -q install ufw

# The rules are a bit loose

ufw default deny incoming
ufw default allow outgoing

ufw allow from 192.0.0.0/8
ufw allow from 10.0.0.0/8

# For Garmin radar
ufw allow from 172.0.0.0/8

# Multicast
ufw allow in proto udp from 239.0.0.0/8
ufw allow in proto udp from 236.0.0.0/8
ufw allow in proto udp from 224.0.0.0/4

ufw enable
