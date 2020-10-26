#!/usr/bin/env bash

#
# Build for Debian in a docker container
#

# bailout on errors and echo commands.
set -xe

DOCKER_SOCK="unix:///var/run/docker.sock"

echo "DOCKER_OPTS=\"-H tcp://127.0.0.1:2375 -H $DOCKER_SOCK -s overlay2\"" | sudo tee /etc/default/docker > /dev/null
sudo service docker restart
sleep 5;

if [ "$EMU" = "on" ]; then
  if [ "$CONTAINER_DISTRO" = "raspbian" ]; then
      docker run --rm --privileged --cap-add=ALL --security-opt="seccomp=unconfined" multiarch/qemu-user-static:register --reset --credential yes --persistent yes
  else
      docker run --rm --privileged --cap-add=ALL --security-opt="seccomp=unconfined" multiarch/qemu-user-static --reset --credential yes --persistent yes
  fi
fi

WORK_DIR=$(pwd):/ci-source

docker run --privileged --cap-add=ALL --security-opt="seccomp=unconfined" -d -ti -e "container=docker"  -v $WORK_DIR:rw $DOCKER_IMAGE /bin/bash
DOCKER_CONTAINER_ID=$(docker ps --last 4 | grep $CONTAINER_DISTRO | awk '{print $1}')

docker exec --privileged -ti $DOCKER_CONTAINER_ID apt-get update
docker exec --privileged -ti $DOCKER_CONTAINER_ID apt-get -y install dpkg-dev debhelper devscripts equivs pkg-config apt-utils fakeroot
docker exec --privileged -ti $DOCKER_CONTAINER_ID apt-get -y install \
  proot git live-build kpartx p7zip p7zip-full parted

docker exec --privileged -ti $DOCKER_CONTAINER_ID /bin/bash -xec \
    "update-alternatives --set fakeroot /usr/bin/fakeroot-tcp; cd ci-source/cross-build-release; chmod -v u+w *.sh; /bin/bash -xe ./raspbian.sh "

docker exec --privileged -ti $DOCKER_CONTAINER_ID /bin/bash -xec \
    cd /lysmarine; export LMBUILD="raspbian"; ./build.sh

echo "Stopping"
docker ps -a
docker stop $DOCKER_CONTAINER_ID
docker rm -v $DOCKER_CONTAINER_ID
