local awful = require("awful")
local beautiful = require("beautiful")

local MenuWidget = {}
MenuWidget.menu = awful.menu({ items = require("settings").menu })

MenuWidget.widget = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = MenuWidget.menu
})

return MenuWidget