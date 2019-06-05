#! /bin/bash

source ./../lib.sh

if [ ! -f "$2" ]; then
     echo "Plz provide an existing file to chroot into"
fi

thisArch=$1
IMAGE=$2
prepare_qemu_for $thisArch "$IMAGE"
"${QEMU_FLAGS[@]}"
