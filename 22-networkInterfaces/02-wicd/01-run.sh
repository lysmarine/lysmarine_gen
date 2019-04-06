on_chroot << EOF
sudo apt update -y
export DEBIAN_FRONTEND=noninteractive
apt install -y wicd wicd-curses wicd-gtk
EOF
