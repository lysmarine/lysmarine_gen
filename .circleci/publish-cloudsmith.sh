#!/usr/bin/env bash

echo "Publishing"

set -x

EXT=$1
REPO=$2
DISTRO=$3

for pkg_file in cross-build-release/release/*/*.$EXT; do
  zipName=$(basename $pkg_file)
  zipDir=$(dirname $pkg_file)
  mkdir ./tmp
  chmod 755 ./tmp
  cd $zipDir || exit 255
  xz -z -9 --threads=4 ${zipName}
  cloudsmith push raw $REPO ${zipName}.xz --summary "LysMarine built by CircleCi on $(date)" --description "LysMarine BBN build"
  RESULT=$?
  if [ $RESULT -eq 144 ]; then
    echo "skipping already deployed $pkg_file"
  fi
done
