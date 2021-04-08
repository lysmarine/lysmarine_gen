# Lysmarine gen
This repository contains all the script and files used to create Lysmarine images. 

The ready to use image and documentation can be found at <http://lysmarineos.com>

---

## Supported Boards 

Since version 0.9.X Lysmarine now have it's custom build tool to be able to compile for multiple single boards computer.

At this time, The tested SBCs are :
 - RaspberryPi 3 (armhf and arm64)
 - PineA64 LTS (based on the Pine64so kernel)
 - Liveusb
 - Desktop install

__Lysmarine probably build out of the box for most armbian supported SBC, it's just a matter of testing and reporting it.__ 


# Content

This repository contains 2 section. The `install-scripts` contain all the steps needed to create lysmarine on a fresh 
install while `cross-build-release` contain the necessary scripts to download the upstream os, mount them, build 
lysmarine and repackage them for distribution.

The repository also include instructions for circle-ci continuous integration and automatic deployment.

### In place build 

```
apt install git
git clone https://github.com/lysmarine/lysmarine_gen.git
sudo mv ./lysmarine_gen/install-scripts / 
cd /install-scripts
sudo chmod -v u+w *.sh
sudo ./install.sh
```
When the build script is done, you need to reboot. Few things are configured on the first boot.


### Build from a host

Install Dependencies
``` 
apt install proot qemu qemu-user git live-build (v1:20190311)
```

Clone repository 
```
git clone https://github.com/lysmarine/lysmarine_gen.git
cd ./lysmarine_gen/cross-build
sudo chmod -v u+w *.sh
```

Build examples:
```
cd ./lysmarine_gen/cross-build

sudo ./build.sh raspios arm64
sudo ./build.sh raspios arm64 customBuild '0 2 4 8'
sudo ./build.sh raspios arm64 TEST bash
```

The build.sh usage goes like this: 
```
Usage: build.sh baseOS processorArchitecture lmVersion stagesToBuild

baseOs options are raspios|armbian-pine64so|debian-live|debian-vbox
processorArchitecture are armhf|arm64|amd64

If you want to have a prompt instide the build env use 'bash' as stagesToBuild argument

```



# Contributors & Testers

Contributors are welcome.

If you are not sure what it means to contribute to an opensource project or github scare you. Message me on facebook <https://fb.me.com/lysmarineOS/> (I speak english and french).

If you don't know where to start, fixing a typo can be enough. There also some issues in the bug tracker marked as 'good first issue'.

If something bigger bother you or you would like to add a feature. Plz open an issue before making a Pull Request so we can discuss it.



# License
Lysmarine and it's scripts are distributed under GPLv3 
Copyright © 2021 Frederic Guilbault

Included Content that belong to others entities are distributed under their respective licences.