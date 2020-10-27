#!/usr/bin/env bash

echo "Publishing"

EXT=$1
REPO=$2
DISTRO=$3

for pkg_file in cross-build-release/release/*/*.img; do
  cloudsmith push raw $REPO/$DISTRO $pkg_file  --version VERSION --summary "LysMarine built by CircleCi on $(date)" --description "LysMarine BBN build"
  RESULT=$?
  if [ $RESULT -eq 144 ]; then
     echo "skipping already deployed $pkg_file"
  fi
done
