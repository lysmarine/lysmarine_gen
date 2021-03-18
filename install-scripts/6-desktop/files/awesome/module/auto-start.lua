-- MODULE AUTO-START


-- Thanks to jo148 on github for making rofi dpi aware!
local filesystem = require('gears.filesystem')
local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local awful = require('awful')
local rofi_command = 'env /usr/bin/rofi -no-cycle -dpi ' .. get_dpi() .. ' -width ' .. with_dpi(400) .. ' -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi.rasi -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

local apps = {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'env sakura',
    rofi = rofi_command,
    browser = 'env chromium',
    editor = 'mousepad', -- gui text editor
    files = 'pcmanfm',
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'nm-applet --indicator', -- wifi
    '/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ', -- credential manager
    '~/.config/autostart',
    "sleep 3 && onboard",
    'xset s off ; xset -dpms ; xset s noblank',
    '/usr/local/bin/wdash',
    'evdev-rce'
  }
}


local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd))
end

for _, app in ipairs(apps.run_on_start_up) do
  run_once(app)
end


