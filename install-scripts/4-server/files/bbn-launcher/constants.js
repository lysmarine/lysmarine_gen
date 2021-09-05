module.exports = {
  commands1 : [
    {name: 'chart', title: 'Chart', img: 'chart', bg: 'Peru', cmd: 'onlyone', args: ['opencpn']},
    {name: 'dash', title: 'Dashboard', img: 'dashboard', bg: 'Olive', cmd: '/opt/kip-dash/kip-dash', args: []},
    {name: 'autopilot', title: 'Autopilot', img: 'autopilot', bg: 'IndianRed', cmd: '/opt/sk-autopilot/sk-autopilot', args: []},
    {name: 'weather', title: 'Weather', img: 'weather', bg: 'RoyalBlue', cmd: 'onlyone', args: ['XyGrib']},
    {name: 'cam', title: 'Camera', img: 'camera', bg: 'SeaGreen', cmd: '/opt/motioneye/motioneye', args: []},

    {name: 'avnav', title: 'AvNav', img: 'chart', bg: 'Olive', cmd: '/opt/AvNav/AvNav', args: []},
    {name: 'freeboard', title: 'Freeboard', img: 'chart', bg: 'SteelBlue', cmd: '/opt/Freeboard-sk/Freeboard-sk', args: []},
    {name: 'pypilot', title: 'PyPilot', img: 'autopilot', bg: 'ForestGreen', cmd: '/opt/Pypilot_webapp/Pypilot_webapp', args: []},
    {name: 'winds', title: 'Winds', img: 'race', bg: 'DarkSeaGreen', cmd: 'gtk-launch', args: ['windy']},
    {name: 't-storms', title: 'T-Storms', img: 'weather', bg: 'Tan', cmd: 'gtk-launch', args: ['lightningmaps']},

    {name: 'music', title: 'Music', img: 'multimedia', bg: 'IndianRed', cmd: '/opt/Iris/Iris', args: []},
    {name: 'video', title: 'Video', img: 'youtube', bg: 'Peru', cmd: '/opt/youtube/youtube', args: []},
    {name: 'commands', title: 'Commands', img: 'travel', bg: 'Tan',  cmd: '/usr/local/bin/bbn-commands', args: []},
    {name: 'www', title: 'WWW', img: 'internet', bg: 'SteelBlue', cmd: 'onlyone', args: ['gnome-www-browser']},
    {name: 'email', title: 'Email', img: 'email', bg: 'RoyalBlue', cmd: 'onlyone', args: ['geary']},
  ],

  commands2 : [
    {name: 'radio', title: 'Radio', img: 'radio', bg: 'IndianRed', cmd: 'onlyone', args: ['fldigi']},
    {name: 'sky', title: 'Sky', img: 'sky', bg: 'Olive', cmd: 'onlyone', args: ['stellarium-augmented']},
    {name: 'marinas', title: 'Moorings', img: 'buoy', bg: 'SaddleBrown', cmd: '/opt/Dockwa/Dockwa', args: []},
    {name: 'web-weather', title: 'Forecast', img: 'weather', bg: 'SeaGreen',  cmd: 'onlyone', args: ['gnome-weather']},
    {name: 'provisioning', title: 'Provisioning', img: 'provisioning', bg: 'Peru',  cmd: 'onlyone', args: ['gnome-www-browser', '/usr/local/share/bbn-checklist/bbn-checklist.html']},

    {name: 'vessel', title: 'Vessel', img: 'ship', bg: 'RoyalBlue',  cmd: 'vessel-data', args: ['']},
    {name: 'signalk', title: 'Signal K', img: 'dashboard', bg: 'ForestGreen', cmd: 'gtk-launch', args: ['signalk']},
    {name: 'terminal', title: 'Terminal', img: 'terminal', bg: 'RoyalBlue',  cmd: 'onlyone', args: ['lxterminal']},
    {name: 'tasks', title: 'Tasks', img: 'tasks', bg: 'Olive',  cmd: 'onlyone', args: ['lxtask']},
    {name: 'files', title: 'Files', img: 'folder', bg: 'ForestGreen', cmd: 'onlyone', args: ['thunar']},

    {name: 'chess', title: 'Chess', img: 'chess', bg: 'Tan', cmd: 'onlyone', args: ['gnome-chess']},
    {name: 'cards', title: 'Cards', img: 'cards', bg: 'SaddleBrown', cmd: 'onlyone', args: ['openpref']},
    {name: 'webcam', title: 'Web Cam', img: 'camera', bg: 'SeaGreen', cmd: 'onlyone', args: ['cheese']},
    {name: 'messenger', title: 'Messenger', img: 'email', bg: 'RoyalBlue', cmd: 'onlyone', args: ['caprine']},
    {name: 'social', title: 'Social', img: 'facebook', bg: 'DarkSeaGreen', cmd: '/opt/facebook/facebook', args: []},
  ],

  commands3 : [
    {name: 'race', title: 'Race', img: 'race', bg: 'SteelBlue',  cmd: 'onlyone', args: ['boats']},
    {name: 'sail', title: 'Sails', img: 'vessel', bg: 'IndianRed',  cmd: 'onlyone', args: ['sailcut']},
    {name: 'instruments', title: 'Instruments', img: 'dashboard', bg: 'SaddleBrown', cmd: '/opt/skwiz/skwiz', args: []},
    {name: 'knots', title: 'Knots', img: 'knot', bg: 'ForestGreen',  cmd: 'onlyone', args: ['gnome-www-browser', '/usr/local/share/knots/knots.html']},
    {name: 'colreg', title: 'ColReg', img: 'colreg', bg: 'Olive',  cmd: 'onlyone', args: ['gnome-www-browser', '/usr/local/share/colreg/colreg.pdf']},

    {name: 'edu', title: 'Education', img: 'school', bg: 'SeaGreen',  cmd: '/opt/Nauticed/Nauticed', args: []},
    {name: 'movies', title: 'Movies', img: 'camera', bg: 'Olive', cmd: 'onlyone', args: ['vlc']},
//  {name: 'ipcam', title: 'IP Camera', img: 'camera', bg: 'SeaGreen', cmd: 'onlyone', args: ['vlc', 'rtsp://<ip-camera-host-or-ip>/channel1']},
  ],

  sites : [
    {name: 'google', url: 'https://google.com/'},
    {name: 'youtube', url: 'https://youtube.com/'},
    {name: 'facebook', url: 'https://m.facebook.com/'},
    {name: 'WA-Web-Msg', url: 'https://web.whatsapp.com/'},
    {name: 'dockwa', url: 'https://dockwa.com/'},
    {name: 'nauticed', url: 'https://nauticed.org/'},
  ]
}