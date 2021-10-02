#!/bin/bash -e

# The rules are a bit loose for multicast

ufw default deny incoming
ufw default allow outgoing

ufw allow from 192.168.0.0/16
ufw allow from 169.254.0.0/16
ufw allow from 10.0.0.0/8

# carrier-grade NAT
ufw allow from 100.64.0.0/10

# For Garmin radar, etc
ufw allow from 172.16.0.0/12

# IPv6
ufw allow from fd00::/8
ufw allow from fe80::/10

# Multicast
ufw allow in proto udp from 224.0.0.0/4

# IPv6
ufw allow in proto udp from ff00::/8

# CanBus
ufw allow in on can0 to any

ufw enable
