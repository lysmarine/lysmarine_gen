
on_chroot << EOF
export DEBIAN_FRONTEND=noninteractive
apt install -y wicd wicd-curses wicd-gtk
EOF
