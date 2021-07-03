#!/bin/bash -e

apt-get install -y -q opencpn opencpn-plugin-celestial opencpn-plugin-launcher opencpn-plugin-radar \
   opencpn-plugin-pypilot opencpn-plugin-objsearch opencpn-plugin-iacfleet imgkap libsglock

#apt-get install -y -q opencpn-gshhs-full opencpn-gshhs-high opencpn-gshhs-intermediate opencpn-gshhs-low opencpn-gshhs-crude
#apt-get install -y -q opencpn-tcdata

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/opencpn.conf-bbn"

apt-get install -y -q -o Dpkg::Options::="--force-overwrite" oernc-pi

if [ $LMARCH == 'arm64' ]; then
  # See https://cloudsmith.io/~david-register/repos/ocpn-plugins-unstable/
  #
  # Chart format plugins
  mkdir oe-tmp
  cd oe-tmp
  wget 'https://dl.cloudsmith.io/public/david-register/ocpn-plugins-unstable/raw/names/oeSENC-4.2-ubuntu-arm64-18.04-tarball/versions/latest/oeSENC-4.2.19.22_ubuntu-18.04-arm64.tar.gz'
  gzip -cd oeSENC-4.2.19.22_ubuntu-18.04-arm64.tar.gz | tar xvf -
  cd oeSENC-4.2-ubuntu-arm64-18.04
  cp -r bin/ lib/ share/ /usr
  cd ../../
  rm -rf oe-tmp

  # Chart format plugins
  mkdir s63-tmp
  cd s63-tmp
  wget https://dl.cloudsmith.io/public/david-register/ocpn-plugins-unstable/raw/names/s63-ubuntu-arm64-18.04-tarball/versions/1.17.1.0.bcaad82/s63_pi-1.17.1-0_ubuntu-arm64-18.04.tar.gz
  gzip -cd s63_pi-1.17.1-0_ubuntu-arm64-18.04.tar.gz | tar xvf -
  cd s63_pi-1.17.1-0_ubuntu-arm64-18.04
  cp -r usr/ /
  cd ../../
  rm -rf s63-tmp

  mkdir o-tmp
  cd o-tmp
  wget https://dl.cloudsmith.io/public/david-register/ocpn-plugins-unstable/raw/names/o-ubuntu-arm64-18.04-tarball/versions/4.2.18.2.0.ab86266/o-charts_pi-4.2.18.2-0_ubuntu-arm64-18.04.tar.gz
  gzip -cd o-charts_pi-4.2.18.2-0_ubuntu-arm64-18.04.tar.gz | tar xvf -
  cd o-charts_pi-4.2.18.2-0_ubuntu-arm64-18.04
  cp -r usr/ /
  cp -r etc/ /
  cd ../../
  rm -rf o-tmp
fi

if [ $LMARCH == 'armhf' ]; then
  apt-get install -y -q                                         \
    oernc-pi                                                    \
    oesenc-pi                                                   \
    ofc-pi                                                      \
    opencpn-doc                                                 \
    opencpn-plugin-calculator                                   \
    opencpn-plugin-celestial                                    \
    opencpn-plugin-chartscale                                   \
    opencpn-plugin-climatology                                  \
    opencpn-plugin-climatology-data                             \
    opencpn-plugin-iacfleet                                     \
    opencpn-plugin-launcher                                     \
    opencpn-plugin-logbookkonni                                 \
    opencpn-plugin-nmeaconverter                                \
    opencpn-plugin-objsearch                                    \
    opencpn-plugin-ocpndebugger                                 \
    opencpn-plugin-plots                                        \
    opencpn-plugin-polar                                        \
    opencpn-plugin-pypilot                                      \
    opencpn-plugin-radar                                        \
    opencpn-plugin-s63                                          \
    opencpn-plugin-sar                                          \
    opencpn-plugin-shipdriver                                   \
    opencpn-plugin-tactics                                      \
    opencpn-plugin-vfkaps                                       \
    opencpn-plugin-watchdog                                     \
    opencpn-plugin-weatherfax                                   \
    opencpn-plugin-weatherrouting                               \
    opencpn-plugin-draw                                         \
    opencpn-sglock-arm32

#  apt-get install -y -q opencpn-tcdata                         \
#    opencpn-plugin-oernc                                       \
#    opencpn-plugin-oesenc
fi
