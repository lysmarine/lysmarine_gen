#!/bin/bash -e
install -d "${ROOTFS_DIR}/usr/share/applications/"
install files/XyGrib.desktop "${ROOTFS_DIR}/usr/share/applications/"

on_chroot << EOF
# For Ubuntu/Debian build and install new version of XyGrib from archive file on https://opengribbs.org
# DomH, 28/08/2018 (modified 21/08/2018, 03/10/2018)
# Based of the script found at https://github.com/dominiquehausser/XyGrib/releases/download/v1.1.1/Xygrib_download_build.sh


# Requested parameters
# Local folders
DefaultInstallDir="/"
AppDir="/usr/local/bin"
DataDir="/usr/local/share/openGribs/XyGrib"
DownloadDir=$(pwd)


# Test if this is a new version
NewRelease=$(wget -nv -qO- https://api.github.com/repos/opengribs/XyGrib/releases/latest | grep -m 1 'tarball_url' | cut -dv -f2 | cut -d'"' -f1)

# Download archive
wget https://github.com/opengribs/XyGrib/archive/v$NewRelease.tar.gz

# Extract files from archive
tar xf v$NewRelease.tar.gz
ExtractNameDir=$(tar -tf  v$NewRelease.tar.gz | head -n 1 | cut -d/ -f1)


# create build directory
mkdir -p $ExtractNameDir/build

# Build and install XyGrib new version
cd $ExtractNameDir/build
cmake -DCMAKE_INSTALL_PREFIX=$InstallDir ..
make 1>Xygrib.std 2>Xygrib.err
string=$(grep $BuildDir"/CMakeFiles 0" ./Xygrib.std)
if [[ $string = *"/usr/bin/cmake -E cmake_progress_start"* ]]; then
        make install
        rm $AppDir"/XyGrib"
        mv $DefaultInstallDir"/XyGrib/XyGrib" $AppDir"/"
        mkdir -p $DataDir
        rm -rf $DataDir"/data"
        mv $DefaultInstallDir"/XyGrib/data" $DataDir"/"
        echo "Successfull new build installed"
        cd $DownloadDir
        rm -rf $ExtractNameDir
        if [ ! -f /home/pi/.local/share/applications/openGrib/XyGrib/data ]; then
                mkdir -p /home/pi/.local/share/applications/openGrib/XyGrib/data
        fi
        mv /usr/local/share/openGrib/XyGrib/data/colors /home/pi/.local/share/applications/openGrib/XyGrib/data
        ln -s /home/pi/.local/share/applications/openGrib/XyGrib/data/colors /usr/local/share/openGribs/XyGrib/data/colors
        rm -rf /XyGrib
else
        less $BuildDir"/Xygrib.err"
        printf "\nFolder "$ExtractNameDir" and subfolders not removed\n"
fi

echo "Done building XyGrib"
EOF
