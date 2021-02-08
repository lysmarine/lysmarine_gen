
## What is LysMarine BBN Edition

This is the fork of the original LysMarine https://github.com/lysmarine/lysmarine_gen by Frederic Guilbault.
It is based on the LysMarine OS, but differs from it in a number of included applications, and the UI features.
Hopefully both forks will be merged eventually into one, but for now it is a distinct OS image.

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

Another useful resource is our previous project (see: https://bareboat-necessities.github.io/my-bareboat/).
Although it is based on OpenPlotter it still is useful to understand hardware and software set up of your marine
raspberry pi.

# Download

CircleCI is the tool which is used to create the OS image.
Binaries are downloadable from: 
 <https://cloudsmith.io/~bbn-projects/repos/bbn-repo/packages/?q=lysmarine>

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)

Package repository hosting is graciously provided by [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.

# Steps to create your own LysMarine BBN Edition image

* Create GitHub account
* Fork this project on GitHub
* Create CircleCi account (Use logging in with GitHub)
* Register .circleci/config.yml in CircleCi
* Create CloudSmith account (Use logging in with GitHub)
* Import CloudSmith key into circleci project settings (via env variable)
* Edit publish-cloudsmith.sh options in .circleci/config.yml to put location of your cloudsmith repository and push the changes into github
* After circleci build completes it will create and upload image to cloudsmith
* You can burn this image using RaspberryPi imager to SD card and use that SD card to boot your raspberry Pi
* You can edit files inside install-scripts directory push them into github and customize your image.

# Passwords

Default passwords are set to 'changeme', which you are supposed to change.
Default user name in login screens is basically 'user'.

# System Requirements

* Raspberry Pi 4 or higher 
* 4 GB memory or higher (2 GB works too but not for many concurrent programs)
* Touchscreen with resolution 1024x600 or higher (800x480 works too but few of the programs will open too big dialog boxes)
* Suitable (unless you find something better) waterproof touchscreen display for your cockpit (Model: SL07W, 
Brand Sihovision, Capacitive Touch Screen 7 inch, (1000 nits), IP65, 1024x600, Cost under $300): https://www.sihovision.com/industrial-touch-monitor/7-inch-industrial-wide-temperaturer-lcd-monitor-with-remote-control-1.html
* WiFi and LTE/4G router (not a requirement, gl-x750 Spitz OpenWrt router): https://www.gl-inet.com/products/gl-x750/
* Quark-elec Marine multiplexers seems has a good product line (or you can just use this LysMarine OS image but
considering all waterproof connectors and hardware customization these commercial multiplexers be nicer choice):
https://www.quark-elec.com/product-category/marine/multiplexers/
* More about hardware: https://bareboat-necessities.github.io/my-bareboat/

# Screenshots

![Lysmarine BBN Screen1](img/lysmarine-bbn-screen1.png?raw=true "Lysmarine BBN Screen1")

![Lysmarine BBN Screen2](img/lysmarine-bbn-screen2.png?raw=true "Lysmarine BBN Screen2")

![Lysmarine BBN Screen3](img/lysmarine-bbn-screen3.png?raw=true "Lysmarine BBN Screen3")

![Lysmarine BBN Screen4](img/lysmarine-bbn-screen4.png?raw=true "Lysmarine BBN Screen4")

# Brief list of applications included:

## Navigation, Instruments

- OpenCPN and plugins
- AvNav
- GPSD
- KPlex
- SignalK and plugins
- Freeboard-SK
- PyPilot
- BBN Launcher
- GNU AIS
- KIP Dashboard
- SK Instrument Panel 
- SK Sail Gauge
- XyGrib Weather GRIB Viewer App
- Stellarium
- CanBoat
- Sail CAD
- Race Instructions / Planning App
- Vessel Specs App
- ColReg 
- Sailing Trip and Provisioning Checklist
- Knots


## Internet

- Chromium Web Browser
- Email Client
- Youtube App
- Facebook App
- Dockwa (Mooring and Marina Booking App)
- NauticEd (Sailing Education)


## Multimedia

- Mopidy Media Player with Web UI (Youtube, Local List, Internet Radio, MPD support)
- MusicBox
- VLC (with IP camera support)
- Audacious


## Radio

- RTL AIS, RTL SDR, GNSS SDR
- Cubic SDR
- Flarq
- Fldigi
- GNU Radio Companion
- CuteSdr
- GPredict
- Gqrx
- Hamfax RadioFax
- JNX NavText
- JWX WeatherFax
- noaa-apt satellite weather
- PreviSat Satellite Tracker
- Quisk SDR
- multimon-ng, netcat
- Chirp


## Protocols

- Samba (Windows Networking)
- CUPS (printing)
- VNC (remote desktop)
- SSH (remote shell)
- NMEA 0183
- SocketCAN, NMEA 2000, can-utils
- OpenVPN (Virtual Private Networking)
- MQTT (Mosquitto) for IoT (to talk to Sonoff smart switches to switch on several devices like Radar,
Windlass, Bow Thruster, Lights)
- WiFi (Access Point and Client)
- SignalK
- Seatalk 1, GPIO
- ModBus (to talk to Victron Venus OS, etc)
- Timeshift (backups), rsync
- PPP, wvdial, picocom for satellite modem support
- I2C tools
- 1-Wire (sensors i.e. for temperature, humidity, pressure, tank levels)
- LoRaWan
- WeatherFax
- NOAA Weather
- NavTex
- Inmarsat Fleet
- SailMail


## Tools

- Text Editor
- File Manager
- Task Manager
- Terminal Application
- Image Viewer
- Calculator
- Calendar
- Weather App
- Chess
- Card Game (Preferans)
- OnBoard touch screen keyboard
- Right click support on touchscreens
- Arduino IDE
- Java (OpenJDK)
- Python
- NodeJS
- C/C++ Compiler and Toolset
- Debian, NPM, PIP, Snap package managers
- rpi-clone
- seahorse


## Data

- InfluxDB
- Grafana

## Add-ons via install scripts

- QtVlm
- TukTuk chartplotter
- DeskPi Pro support
- Text-To-Speech App
- AnBox (experimantal Android app support)
- Touchscreen calibration
- NMEA Sleuth Chromium Plugin
- NodeRed
- PACTOR
- SdrGlut
- WxToImg
- OS Settings
- Timezone Setup
- Predict (Satellite Tracker for scripting)
- Scytale-C Inmarsat Decoders
- Pat SailMail


# License

Lysmarine scripts distributed under GPLv3
Copyright © 2020 Frederic Guilbault
