#! /bin/bash -e

source ./config ;

if [[ -z $LMARCH ]];then
  export LMARCH="$(dpkg --print-architecture)"
  echo $LMARCH
fi

if [[ -z $LMOS ]];then
  export LMOS="$(lsb_release -id -s | head -1)"
fi

run_stage() {
  if [ -f $1/run.sh ]; then
    echo '';
    echo '==========================================';
    echo "Running number $1 "
    echo "$2/run.sh"
    echo '==========================================';
    echo '';

    export FILE_FOLDER=$1/files/
    $1/run.sh 2>&1 | tee "logs/$1.log"
  fi
} 



echo "";
echo "Install script for Lysmarine :)"
echo "";

if [[ -z $LMBUILD ]];then
  echo ''
  echo ''
  echo "variable $LMBUILD is not set, choices are: "
  echo ''
  echo "export LMBUILD=debian-vbox"
  echo "export LMBUILD=raspbian"
  echo "export LMBUILD=armbian-pineA64"
  echo "export LMBUILD=debian-64"
  echo ''
  exit
fi



## This help making less noice in cross-build environment. 
export LANG="en_US.UTF-8"
export LANGUAGE=en_US:en
export LC_NUMERIC="C"
export LC_CTYPE="C"
export LC_MESSAGES="C"
export LC_ALL="C"




if [ "$#" -gt "0" ]; then
  stageList="$@"
else
  stageList="*" 
fi




for number in $stageList; do
  for stage in ./$number*; do
    if [ -d $stage ]; then
      run_stage $stage
    fi
  done
done


echo "";
echo "Done Installing script for Lysmarine $ARCH :)"
echo "";