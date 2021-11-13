
## What is LysMarine BBN Edition

This is the fork of the original LysMarine https://github.com/lysmarine/lysmarine_gen by Frederic Guilbault.
It is based on the LysMarine OS, but differs from it in a number of included applications, and the UI features.
Now it is a distinct OS image.

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

# Getting Started

See:
https://bareboat-necessities.github.io/my-bareboat/bareboat-os.html

# System Requirements

* Raspberry Pi 4 or higher (or CM4 module 4Gb with Wi-Fi, or raspberry pi 400)
* 4 GB memory or higher (2 GB works too but not for many concurrent programs)
* Touchscreen with resolution 1024x600 or higher (800x480 works too but few of the programs will open too big dialog boxes)
* Suitable (unless you find something better) waterproof touchscreen display for your cockpit (Model: SL07W, 
Brand Sihovision, Capacitive Touch Screen 7 inch, (1000 nits), IP65, 1024x600, Cost under $300): https://www.sihovision.com/industrial-touch-monitor/7-inch-industrial-wide-temperaturer-lcd-monitor-with-remote-control-1.html
* WiFi and LTE/4G router (not a requirement, gl-x750 Spitz OpenWrt router): https://www.gl-inet.com/products/gl-x750/
* Quark-elec Marine multiplexers seems has a good product line (or you can just use this LysMarine OS image but
considering all waterproof connectors and hardware customization these commercial multiplexers be nicer choice):
https://www.quark-elec.com/product-category/marine/multiplexers/ Another (even cheaper) option: http://www.yakbitz.com/
* More about hardware: https://bareboat-necessities.github.io/my-bareboat/


# Download

To get start it's easier to download pre-built image using the links below (or you can build your own 
following instructions in the next chapter). 
CircleCI is the tool which is used to create the OS image.

NOTE: Do not forget to set WiFi country after the installation.

Binaries are downloadable from: 
 <https://cloudsmith.io/~bbn-projects/repos/bbn-repo/packages/?q=lysmarine>

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)

Package repository hosting is graciously provided by [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.

If Cloudsmith download link does not work for you, check 
[Getting Started Guide](https://bareboat-necessities.github.io/my-bareboat/bareboat-os.html). It contains 
an alternative download location.

# Passwords

Default passwords are set to 'changeme', which you are supposed to change.
Default user name in login screens is 'user'.


# Screenshots

![Lysmarine BBN Screen1](img/lysmarine-bbn-screen1.png?raw=true "Lysmarine BBN Screen1")

![Lysmarine BBN Screen2](img/lysmarine-bbn-screen2.png?raw=true "Lysmarine BBN Screen2")

![Lysmarine BBN Screen3](img/lysmarine-bbn-screen3.png?raw=true "Lysmarine BBN Screen3")

![Lysmarine BBN Screen4](img/lysmarine-bbn-screen4.png?raw=true "Lysmarine BBN Screen4")


# Brief list of applications included:

## Navigation, Instruments

- [OpenCPN](https://opencpn.org/) and plugins
- [AvNav](https://github.com/wellenvogel/avnav)
- [GPSD](https://en.wikipedia.org/wiki/Gpsd)
- [KPlex](http://www.stripydog.com/kplex/)
- [SignalK](https://signalk.org/) and plugins
- [Freeboard-SK](https://github.com/SignalK/freeboard-sk)
- [SK Instrument Panel](https://github.com/SignalK/instrumentpanel)
- [KIP Dashboard](https://github.com/mxtommy/Kip)
- [SKWiz Instrument Panel](https://www.npmjs.com/package/skwiz)
- [PyPilot](https://pypilot.org/)
- [BBN Launcher](https://github.com/bareboat-necessities/lysmarine_gen/tree/master/install-scripts/4-server/files/bbn-launcher)
- [SK Sail Gauge](https://github.com/SignalK/sailgauge)
- [XyGrib](https://opengribs.org/en/xygrib) Weather GRIB Viewer App
- [Stellarium](http://stellarium.org/)
- [CanBoat](https://github.com/canboat)
- [Sail CAD](http://www.sailcut.com/)
- [Race Instructions / Planning App](http://boats.sourceforge.net/)
- Vessel Specs App
- ColReg 
- [Sailing Trip and Provisioning Checklist](https://bareboat-necessities.github.io/my-bareboat/bareboat-equipment-checklist)
- Knots
- [JTides](https://arachnoid.com/JTides/)
- [TukTuk chartplotter](https://github.com/vokkim/tuktuk-chart-plotter)
- [Nautic](https://sourceforge.net/projects/nauticalmanac/)
- [PC-NavTex](https://github.com/juerec/pc-navtex)


## Internet

- Chromium Web Browser
- Email Client
- Internet Messaging Client [Empathy](https://github.com/GNOME/empathy)
- FB Messenger [Caprine](https://github.com/sindresorhus/caprine)
- Youtube App
- Facebook App
- Internet Weather
- Dockwa (Mooring and Marina Booking App)
- NauticEd (Sailing Education)
- Lightning Maps
- Windy
- Marine Traffic


## Multimedia

- [Mopidy](https://mopidy.com/) Media Player with Web UI (Youtube, Local List, Internet Radio, MPD support)
- [MusicBox](https://mopidy.com/ext/musicbox-webclient/) (Music Player)
- [Iris](https://github.com/jaedb/Iris) (Music Player)
- [VLC](https://www.videolan.org/vlc/) (with IP camera support)
- [Audacious](https://github.com/audacious-media-player)
- [MotionEye](https://github.com/ccrisan/motioneye) (Cameras Control)
- [shairport-sync](https://github.com/mikebrady/shairport-sync) (AirPlay)
- [raspotify](https://github.com/dtcooper/raspotify) (Raspotify)


## Radio

- [Cubic SDR](https://cubicsdr.com/)
- [Flarq](http://www.w1hkj.com/flarq_main.html)
- [Fldigi](http://www.w1hkj.com/)
- [GNU Radio Companion](https://github.com/gnuradio/gnuradio)
- [CuteSdr](https://directory.fsf.org/wiki/Cutesdr)
- [GPredict](http://gpredict.oz9aec.net/)
- [Gqrx](https://gqrx.dk/)
- [Hamfax RadioFax](http://hamfax.sourceforge.net/)
- [JNX NavText](https://arachnoid.com/JNX/)
- [JWX WeatherFax](https://arachnoid.com/JWX/)
- [noaa-apt satellite weather](https://noaa-apt.mbernardi.com.ar/)
- [PreviSat Satellite Tracker](http://previsat.sourceforge.net/)
- [Quisk SDR](https://james.ahlstrom.name/quisk/)
- [multimon-ng](https://github.com/EliasOenal/multimon-ng), netcat
- [Chirp](https://chirp.danplanet.com/)
- [GNU AIS](http://gnuais.sourceforge.net/)
- [DireWolf](https://github.com/wb2osz/direwolf)
- [YAAC](https://www.ka2ddo.org/ka2ddo/YAAC.html)
- [morse2ascii](https://packages.ubuntu.com/bionic/morse2ascii)
- [APRX](https://github.com/PhirePhly/aprx)
- [dump1090-fa](https://github.com/adsbxchange/dump1090-fa)
- [PiAware](https://flightaware.com/adsb/piaware/)
- RTL AIS
- RTL-SDR
- GNSS-SDR
- HackRF
- AirSpy
- OsmoSDR
- soapysdr-tools


## Protocols

- [Samba (Windows Networking)](https://www.samba.org/)
- CUPS (printing)
- VNC (remote desktop)
- SSH (remote shell)
- NMEA 0183
- SocketCAN, NMEA 2000, [can-utils](https://github.com/linux-can/can-utils)
- [OpenVPN (Virtual Private Networking)](https://openvpn.net/)
- MQTT [Mosquitto](https://mosquitto.org/) for IoT (to talk to Sonoff smart switches to switch on several devices like Radar,
Windlass, Bow Thruster, Lights)
- WiFi (Access Point and Client)
- [SignalK](https://signalk.org/)
- Seatalk 1, GPIO
- ModBus (to talk to Victron Venus OS, etc)
- [Timeshift](https://github.com/teejee2008/timeshift) (backups), [rsync](https://rsync.samba.org/)
- PPP, wvdial, picocom for satellite modem support
- I2C tools
- 1-Wire (sensors i.e. for temperature, humidity, pressure, tank levels)
- LoRaWan
- WeatherFax
- NOAA Weather
- NavTex
- Inmarsat Fleet
- WinLink
- SMS (Using Gammu)
- Bluetooth (File Transfer)
- AirPlay (via shairport-sync)


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
- [Card Game (Preferans)](http://openpref.sourceforge.net/)
- [OnBoard](https://launchpad.net/onboard) touch screen keyboard
- [Right click support on touchscreens](https://github.com/bareboat-necessities/evdev-right-click-emulation)
- [Arduino IDE](https://www.arduino.cc/en/software)
- [Java (OpenJDK)](https://openjdk.java.net/)
- [Python](https://www.python.org/)
- [NodeJS](https://nodejs.org/en/)
- C/C++ Compiler and Toolset
- Debian, NPM, PIP, Snap package managers
- [rpi-clone](https://github.com/billw2/rpi-clone) (SSD cloning)
- Pi Imager, piclone
- [seahorse](https://wiki.debian.org/Seahorse) (Password Management)
- [Gammu](https://wammu.eu/smsd/) (SMS Client)
- [Timeshift](https://github.com/teejee2008/timeshift) (backups)
- [scrcpy](https://github.com/Genymobile/scrcpy) (Android Mirroring)


## Data

- [InfluxDB](https://www.influxdata.com/)
- [Grafana](https://grafana.com/)
- [NodeRed embedded into SignalK](https://nodered.org/)
- [Chronograf](https://github.com/influxdata/chronograf)
- [Kapacitor](https://github.com/influxdata/kapacitor)


## Add-ons via install scripts

- [QtVlm](https://www.meltemus.com/)
- [DeskPi Pro](https://github.com/DeskPi-Team/deskpi) support
- ArgonOne case support
- Text-To-Speech App
- [AnBox](https://anbox.io/) (experimental Android app support)
- Touchscreen calibration
- [NMEA Sleuth Chromium Plugin](https://chrome.google.com/webstore/detail/nmea-sleuth/pkikkfglomloligndkaibecgapljgjok?hl=en)
- PACTOR
- [SdrGlut](https://github.com/righthalfplane/SdrGlut)
- [WxToImg](https://wxtoimgrestored.xyz/)
- OS Settings
- Timezone Setup
- Change Password
- Predict (Satellite Tracker for scripting)
- [Scytale-C](https://bitbucket.org/scytalec/scytalec/) Inmarsat Decoders
- [Pat / WinLink](https://github.com/la5nta/pat)
- [Widevine](https://www.widevine.com/) Digital Content Protection


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


# License

Lysmarine scripts distributed under GPLv3

Copyright © 2020 Frederic Guilbault

Copyright © 2021 mgrouch

Included content copyrighted by other entities distributed under their respective licenses.
