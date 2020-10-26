# Lysmarine gen
Tool used to create lysmarine image.
The ready to use image can be found at <http://lysmarineos.com>

---

## Supported Boards 
Since version 0.9.X lysmarine now have it's custom build tool to be able to compile for multiple single boards computer.

At this time, The tested SBCs are :
 - RaspberryPi

Others SBC related supported arch might work out of the box but haven't been tested, others 
might need some tweaks to build correctly. 

__If you wish to have your favorite SBC supported and have some time to do testing ...or have a spare to giveaway. 
Open a github issue or contact me on facebook https://fb.me.com/lysmarineOS/__

# Build directly on the single board computer

#### Dependencies
``` 
apt install git
```
#### Launch the build script
As root:
```
git clone https://github.com/bareboat-necessities/lysmarine_gen.git
mv lysmarine_gen/install-scripts /lysmarine
cd /lysmarine; export LMBUILD="raspbian"; ./install.sh
```
When the build script is done, you need to reboot. As few things are configured on the first boot. 

# Contributors & Testers

If you don't know where to start. Fixing a typo can be enough, There also some issues in the bug tracker marked as 
'good first issue'. If something bother you or you would like to add a feature. Plz open an issue before 
making a Pull Request.

I'm friendly to first time contributors, if you are not sure what in mean to contribute to an opensource software
or github scare you. Message me on facebook <https://fb.me.com/lysmarineOS/> (I speak English and French). 

# License

Lysmarine scripts are distributed under GPLv3
Copyright © 2020 Frederic Guilbault
