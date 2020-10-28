#!/bin/bash -xe

echo "Publishing"

EXT=$1
REPO=$2
DISTRO=$3

pwd
ls

for pkg_file in cross-build-release/release/*/*.$EXT; do
  zipName=$(basename $pkg_file)
  zip ./${zipName}.zip ${pkg_file}
  cloudsmith push raw $REPO ./${zipName}.zip --summary "LysMarine built by CircleCi on $(date)" --description "LysMarine BBN build"
  RESULT=$?
  if [ $RESULT -eq 144 ]; then
     echo "skipping already deployed $pkg_file"
  fi
done
