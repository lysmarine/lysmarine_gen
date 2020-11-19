# LysMarine gen
Tool used to create LysMarine image on CircleCI.
The ready to use image can be found at: <https://cloudsmith.io/~bbn-projects/repos/bbn-repo/packages/?q=lysmarine>

---

## Supported Boards 

At this time targeted SBCs are :
 - RaspberryPi

__If you wish to have your favorite SBC supported and if you have some time for testing ...or have a spare to giveaway. 
Open a github issue or contact me on facebook https://fb.me.com/lysmarineOS/__

# Steps to create your own LysMarine image

* Create GitHub account
* Fork this project on GitHub
* Create CircleCi account (Use logging in with GitHub)
* Register .circleci/config.yml in CircleCi
* Create CloudSmith account (Use logging in with GitHub)
* Import CloudSmith key into circleci project settings (via env variable)
* Edit publish-cloudsmith.sh options in .circleci/config.yml to put location of your cloudsmith repository and push
  the changes into github
* After circleci build completes it will create and upload image to cloudsmith
* You can burn this image using RaspberryPi imager to SD card and use that SD card to boot your raspberry Pi
* You can edit files inside install-scripts directory push them into github and customize your image.

# Contributors & Testers

If you don't know where to start, fixing a typo can be enough. There are also some issues in the bug tracker marked as
'good first issue'. If something bothers you or you would like to add a feature, plz, open an issue before
making a Pull Request.

I'm friendly to first time contributors. If you are not sure what it means to contribute to the open source software
or GitHub scares you, message me on facebook <https://fb.me.com/lysmarineOS/> (I speak English and French). 

# License

Lysmarine scripts distributed under GPLv3
Copyright © 2020 Frederic Guilbault
