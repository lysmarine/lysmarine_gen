# Lysmarine gen
Tool used to create lysmarine image.
The ready to use image can be found at <http://lysmarineos.com>

---

## Supported Boards 
Since verson 0.9.X lysmarine now have it's custom build tool to be able to compile for multiple single boards computer.

At this time, The tested SBCs are :
 - RaspberryPi 3 
 - PineA64 LTS (based on the Pine64so kernel)
 - virtualbox disk image

Others SBC related suported arch might work out of the box but haven't been tested, others might need tweeks to build correctly. 

__If you wish to have your favorite SBC supported and have some time to do testing ...or have a spare to giveaway. Open a github issue or contact me on facebook https://fb.me.com/lysmarineOS/__

# Cross-build on a host machine

lysmarine-gen have been develop to build on a linux mint host and have been tested on debian.

#### Install Dependencies
``` 
apt install proot qemu qemu-user git live-build
```

#### Install lysmarine-gen 
```
git clone https://github.com/lysmarine/lysmarine_gen.git
cd ./lysmarine_gen/cross-build
sudo chmod -v u+w *.sh
```

#### Setup the cross-build environement and get in it 
```
cd ./lysmarine_gen/cross-build
sudo ./raspbian.sh #or the build script available you would like
```

#### Once in the chroot environement, launch lysmarine build script
```
cd /lysmarine; export LMBUILD="raspbian"; ./build.sh
```

When starting the build script, it's possible to build only a list of specified stages by  providing arguments to build.sh
  
Example, to build the minimal GUI :
``` 
./build.sh 10 15 18 20 50 55 60 98
```
When the script is done, you need to `exit;` The resulting image will be located in `./lysmarine_gen/cross-build/release/`

# Build directly on the single bord computer

#### Dependencies
``` 
apt install git
```
#### Launch the build script
As root:
```
git clone https://github.com/lysmarine/lysmarine_gen.git
mv lysmarine_gen/lysmarine /lysmarine
cd /lysmarine; export LMBUILD="raspbian"; ./build.sh
```
When the build script is done, you need to reboot. As few things are configured on the first boot. 


# Contributors & Testers

If you don't know where to start. Fixing a typo can be enough, There also some issues in the bug tracker marked as 'good first issue'. If something bother you or you would like to add a feature. Plz open an issue before making a Pull Request.

Im friendly to first time contributors, if you are not sure what in mean to contribute to an opensource software or github scare you. Message me on facebook <https://fb.me.com/lysmarineOS/> (I speak english and french). 


# License

Lysmarine scripts are distributed under GPLv3 
Copyright © 2020 Frederic Guilbault
