# LysMarine gen
Tool used to create LysMarine image on CircleCI.
The ready to use image can be found at: <https://cloudsmith.io/~bbn-projects/repos/bbn-repo/packages/?q=lysmarine>

---

## What is LysMarine

What started as an effort to build a marine linux OS turned out into much more interesting.
Our focus was to build a marine computer OS to be used on boats for the navigation and on touch screens in a cockpit of a boat.
By nature marine navigation is very demanding. Much more demanding than a car computer. There was a need for: 

* good touch screen support (even with small screens) (GTK3, budgie)
* ability to easily connect to a variety of sensors GPS, IMU, environment (temp, pressure, humidity, wind), autopilot, bilge water level, and much more (SignalK/Kplex NMEA are built-in)
* ability to control other hardware (started with controlling steering of the boat and autopilot). We have pyPilot built-in.
* weather information retrieving, processing, mapping and visualizing (it's often a matter of survival on a boat)
* weather routing and climatology
* a media player (who doesn't want to play some music being on a boat, so here we go with MPD player, Mopidy and more)
* internet connectivity, VPN, cellular 4G/LTE, satellite, Wi-Fi
* celestial navigation (brought us astronomy software, so we package Stellarium and more)
* cartography and navigation (We have OpenCPN, FreeBoard-SK, AvNav chart plotters). While our focus was marine charts, our distribution can be easily adapted for a car navigation system.
* software defined radio SDR (HAM radio community might take some interest), AIS, weather (NOAA, weather fax, NavTex), Inmarsat Fleet
* satellite internet via Iridium
* low power consumption (so we built it for the ARM based processors)

We would think our distribution can serve as a basis for others interested to build either:

* Car specialized Linux distribution
* Weather station under Linux
* Home automation Linux distribution
* Astronomy related Linux distribution
* Music/Media player Linux distribution
* HAM radio SDR Linux distribution
* Generic Linux touch tablet on ARM raspberry OS
* WiFi router

The code of building is distribution is easily customizable following instructions below.
You do not have to build it on your own ARM hardware. The process described below explains how you
can make it to build it directly from your source code on GitHib via CircleCi and distribute it on CloudSmith
or other place. It doesn't take that much effort or coding, some dedication required (surely).

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

# Passwords

Default passwords are set to 'changeme', which you are supposed to change.
Default user name in login screens is basically 'user'.

# Contributors & Testers

If you don't know where to start, fixing a typo can be enough. There are also some issues in the bug tracker marked as
'good first issue'. If something bothers you or you would like to add a feature, plz, open an issue before
making a Pull Request.

I'm friendly to first time contributors. If you are not sure what it means to contribute to the open source software
or GitHub scares you, message me on facebook <https://fb.me.com/lysmarineOS/> (I speak English and French). 

# License

Lysmarine scripts distributed under GPLv3
Copyright © 2020 Frederic Guilbault
