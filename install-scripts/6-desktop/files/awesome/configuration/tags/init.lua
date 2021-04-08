local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')
local apps = require('configuration.apps')

local tags = {
  {
    icon = icons.chrome,
    type = 'chrome',
    defaultApp = apps.default.browser,
    screen = 1
  },
}

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.max
}

awful.screen.connect_for_each_screen(function(s)
  for i, tag in pairs(tags) do
    awful.tag.add(i,
      {
        icon = tag.icon,
        icon_only = true,
        layout = awful.layout.suit.tile,
        gap_single_client = false,
        gap = 4,
        screen = s,
        defaultApp = tag.defaultApp,
        selected = i == 1
      })
  end
end)

_G.tag.connect_signal('property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 0
    else
      t.gap = 4
    end
  end)
