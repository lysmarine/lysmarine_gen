#!/bin/bash -e

apt-get install -y -q opencpn libsglock

# TODO: opencpn-plugin-celestial opencpn-plugin-launcher opencpn-plugin-pypilot opencpn-plugin-objsearch opencpn-plugin-iacfleet opencpn-plugin-radar imgkap

#apt-get install -y -q opencpn-gshhs-full opencpn-gshhs-high opencpn-gshhs-intermediate opencpn-gshhs-low opencpn-gshhs-crude
#apt-get install -y -q opencpn-tcdata

install -o 1000 -g 1000 -d "/home/user/.opencpn"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/"
install -o 1000 -g 1000 -v $FILE_FOLDER/opencpn.conf "/home/user/.opencpn/opencpn.conf-bbn"

# TODO: apt-get install -y -q -o Dpkg::Options::="--force-overwrite" oernc-pi

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
    ofc-pi                                                      \
    opencpn-doc                                                 \
    opencpn-plugin-calculator                                   \
    opencpn-plugin-chartscale                                   \
    opencpn-plugin-climatology                                  \
    opencpn-plugin-climatology-data                             \
    opencpn-plugin-logbookkonni                                 \
    opencpn-plugin-nmeaconverter                                \
    opencpn-plugin-ocpndebugger                                 \
    opencpn-plugin-plots                                        \
    opencpn-plugin-polar                                        \
    opencpn-plugin-s63                                          \
    opencpn-plugin-sar                                          \
    opencpn-plugin-shipdriver                                   \
    opencpn-plugin-tactics                                      \
    opencpn-plugin-watchdog                                     \
    opencpn-plugin-weatherfax                                   \
    opencpn-plugin-weatherrouting                               \
    opencpn-plugin-draw                                         \
    opencpn-sglock-arm32

# TODO:
#    oernc-pi                                                    \
#    oesenc-pi                                                   \
#    opencpn-plugin-celestial                                    \
#    opencpn-plugin-iacfleet                                     \
#    opencpn-plugin-launcher                                     \
#    opencpn-plugin-objsearch                                    \
#    opencpn-plugin-pypilot                                      \
#    opencpn-plugin-vfkaps                                       \
#    opencpn-plugin-radar                                        \

#  apt-get install -y -q opencpn-tcdata                         \
#    opencpn-plugin-oernc                                       \
#    opencpn-plugin-oesenc
fi

# Install plugin bundle
mkdir tmp-o-bundle-$LMARCH || exit 2
cd tmp-o-bundle-$LMARCH

wget -O opencpn-plugins-bundle-$LMARCH.tar.gz https://github.com/bareboat-necessities/opencpn-plugins-bundle/blob/main/bundles/opencpn-plugins-bundle-$LMARCH.tar.gz?raw=true
gzip -cd opencpn-plugins-bundle-$LMARCH.tar.gz | tar xvf -

cp -r -p lib/* /usr/lib/
cp -r -p bin/* /usr/bin/
cp -r -p share/* /usr/share/

cd ..
rm -rf tmp-o-bundle-$LMARCH


# Polar Diagrams

BK_DIR="$(pwd)"

mkdir /home/user/Polars && cd /home/user/Polars

wget https://www.seapilot.com/wp-content/uploads/2018/05/All_polar_files.zip
unzip All_polar_files.zip
chown user:user ./*
chmod 664 ./*
rm All_polar_files.zip

cd "$BK_DIR"
