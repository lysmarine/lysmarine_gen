#! /bin/bash
echo "";
echo "Install script for Lysmarine $ARCH :)"
echo "";


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
            echo "running number :$number "
            echo "$stage/run.sh"
            echo '==========================================';
            echo '';

                export FILE_FOLDER=$stage/files/
                  if [ -f $stage/run.sh ]; then

                    $stage/run.sh
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
          $stage/run.sh
        fi

  fi
  done ;


  echo "";
  echo "Done Installing script for Lysmarine $ARCH :)"
  echo "";
fi
