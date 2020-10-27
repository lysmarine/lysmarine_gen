#!/usr/bin/env bash

echo "Publishing"

EXT=$1
REPO=$2
DISTRO=$3

pwd
ls

for pkg_file in cross-build-release/release/*/*.$EXT; do
  cloudsmith push raw $REPO $pkg_file --summary "LysMarine built by CircleCi on $(date)" --description "LysMarine BBN build"
  RESULT=$?
  if [ $RESULT -eq 144 ]; then
     echo "skipping already deployed $pkg_file"
  fi
done
