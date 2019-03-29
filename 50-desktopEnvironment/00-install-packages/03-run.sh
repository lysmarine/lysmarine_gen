
on_chroot << EOF
chown 1000:1000 /home/pi/.local
chown 1000:1000 /home/pi/.local/share #luakit change it to root.
EOF
