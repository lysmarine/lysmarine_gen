#! /bin/bash
echo "";
echo "Install script for Lysmarine $ARCH :)"
echo "";
source ./config ;

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

mkdir log

export LANG="en_US.UTF-8"
export LANGUAGE=en_US:en
export LC_NUMERIC="C"
export LC_CTYPE="C"
export LC_MESSAGES="C"
export LC_ALL="C"



if [ "$#" -gt "0" ]; then


  for number in "$@"; do
      for stage in ./$number*; do
        if [ -d $stage ]; then
            echo '';
            echo '==========================================';
            echo "Running number :$number "
            echo "$stage/run.sh"
            echo '==========================================';
            echo '';

            export FILE_FOLDER=$stage/files/
            if [ -f $stage/run.sh ]; then
              $stage/run.sh 2>&1 | tee "log/$stage.log"
            fi
        fi
      done
    done
  else


  for stage in ./{00..99}*; do
    if [ -d $stage ]; then

      echo '';
      echo '==========================================';
      echo " Running $stage ..."
      echo "$stage/run.sh "
      echo '==========================================';
      echo '';

      export FILE_FOLDER="$(pwd)/$stage/files/"
        if [ -f $stage/run.sh ]; then
          $stage/run.sh 2>&1 | tee "log/$stage.log"
        fi
    fi
  done ;


  echo "";
  echo "Done Installing script for Lysmarine $ARCH :)"
  echo "";
fi
