#!/bin/bash

## Install dependencies
apt-get -yq install gir1.2-webkit2-4.0 qt5-qmake pyqt5-dev

apt-get -yq install python3-pyqt5.qtwebengine

# p   python3-pyqt5.qtwebengine                                                                                      - Python 3 bindings for Qt5's WebEngine module                                                                             
# p   python3-pyside2.qtwebengine                                                                                    - Python bindings for Qt5 Web Engine (Python 3)                                                                            
# p   python3-pyside2.qtwebenginecore                                                                                - Python bindings for Qt5 WebEngineCore module (Python 3)                                                                  
# p   python3-pyside2.qtwebenginewidgets                                                                             - Python bindings for Qt5 WebEngineWidgets module (Python 3) 
#  /QtWebEngineCoremod.sip: line 25: column 9: 'QtCore/QtCoremod.sip' could not be found
# /QtWebEngineCoremod.sip: line 26: column 9: 'QtGui/QtGuimod.sip' could not be found
#  /QtWebEngineCoremod.sip: line 27: column 9: 'QtNetwork/QtNetworkmod.sip' could not be found


pip3 install --upgrade pip

pip3 install setuptools
pip install pywebview
pip install qtpy

# pip3 install pyqt5-dev 
#pip3 install pyqt5-sip
#pip3 install pyqt5 

# pip3 install pyqt5-sip-dev
# pip3 install pywebview PyQtWebEngine 

## Copy files
# install -v -m 0755 $FILE_FOLDER/Freeboard-sk.py "/usr/local/bin/Freeboard-sk"
install -v -m 0755 $FILE_FOLDER/Pypilot_webapp.py "/usr/local/bin/Pypilot_webapp"
install -v -m 0755 $FILE_FOLDER/signalk_webapp.py "/usr/local/bin/signalk_webapp"
install -v -m 0755 $FILE_FOLDER/avnav_webapp.py "/usr/local/bin/avnav_webapp"
install -v -m 0755 $FILE_FOLDER/wdash.py "/usr/local/bin/wdash"

## todo for icon support
#python -m pyinstaller --icon    myscript.spec
#https://github.com/r0x0r/pywebview/issues/91

## Install icons and .desktop files for each service
install -d -o 1000 -g 1000 "/home/user/.local/share/icons"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/freeboard-sk.png "/home/user/.local/share/icons/freeboard-sk.png"
install -v -o 1000 -g 1000 -m 644 $FILE_FOLDER/signalk.png "/home/user/.local/share/icons/"
install -d /usr/local/share/applications
install -v $FILE_FOLDER/signalk.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/avnav_webapp.desktop "/usr/local/share/applications/"

install -d "/usr/local/share/icons/"
install -m 644  $FILE_FOLDER/signalk.png "/usr/local/share/icons/"

install -d /usr/local/share/applications
install -v $FILE_FOLDER/pypilot_calibration.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/pypilot_webapp.desktop "/usr/local/share/applications/" # NOTE Depend on stage 6.6

