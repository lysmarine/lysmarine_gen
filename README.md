===== Lysmarine gen =====

Tool used to create lysmarine image.
Since verson 0.9.X lysmarine now have it's custom build tool to be able to compile for multiple single boards computer.

At this time, The tested SBCs are :
 - RaspberryPi 3 
 - PineA64 LTS (based on the Pine64so kernel)
 - virtualbox disk image

Others SBC related suported arch might work out of the box but haven't been tested, others might need tweeks to build correctly. 
__If you wish to have your favorite SBC supported and have some time to do testing ...or have a spare to giveaway. Open a github issue or contact me on facebook https://fb.me.com/lysmarineOS/__

===== Build on a host machine =====

Currently, it's designed to build on debian and linux mint.
*Documentation and contributions to support other operating system is welcome.*

Dependencies
``` 
apt install proot qemu git
```

To Install lysmarine-gen 
```
git clone https://github.com/lysmarine/lysmarine_gen.git
cd ./lysmarine_gen/buildscript
sudo chmod -v u+w *.sh
```

To prepare and get in the build environement:
```
cd ./lysmarine_gen/buildscript
sudo ./raspbian.sh #or the build script available you would like
```

Once in the build environment. 
```
cd /lysmarine; export LMBUILD="raspbian"; ./build.sh
```
To start the build process. For developement and debugging purpus it's possible to build only a list of specified stages by specifying them as argument of the build.sh script 
Example, to build the minimal GUI :
``` 
./build.sh 10 15 18 20 50 55 60 98
```

Resulting image will be located in `./lysmarine_gen/buildscript/release/`

===== Build on the target single bord computer =====

Dependencies
``` 
apt install git
```

As root:
```
git clone https://github.com/lysmarine/lysmarine_gen.git
mv lysmarine_gen/lysmarine /lysmarine
cd /lysmarine; export LMBUILD="raspbian"; ./build.sh
```

===== Contributors & Testers =====

If you don't know where to start, Start anywhere or check the issues tracker for the one marked a 'easy win'

Im friendly to first time contributors, if you are not sure what in mean to contribute to an opensource software or github scare you. 
Message me on facebook https://fb.me.com/lysmarineOS/ I speak english and french. 

>In fact I feel alone and a bit overwhelmed by the task :) 
--Frederic Guilbault



===== License =====

Lysmarine scripts are distributed under GPL3 License

---
__ Lysmarine didin't work for you and you are mad ?. 
Let the hate flow through you, when it reach it's climax, open an issue give it the best you have. I love hate mail. __