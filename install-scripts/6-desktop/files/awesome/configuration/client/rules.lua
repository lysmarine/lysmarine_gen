local awful = require('awful')
local gears = require('gears')
local client_buttons = require('configuration.client.buttons')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
      --floating = false, -- This break opencpn
      maximized = false,
      above = false,
      below = false,
      ontop = false,
      sticky = false,
      maximized_horizontal = false,
      maximized_vertical = false
    }
  },
  {
    rule_any = { name = { 'QuakeTerminal' } },
    properties = { skip_decoration = true }
  },
  {
    rule_any = { name = { 'Onboard' } },
    properties = {
      skip_decoration = true,
      floating = true,
      placement = awful.placement.bottom,
      focusable = false,
      honor_workarea = true,
      honor_padding = true,
      ontop = true,
      maximized_horizontal = true
    }
  },
  -- Titlebars
  {
    rule_any = { type = { 'dialog' }, class = { 'Wicd-client.py', 'calendar.google.com' } },
    except_any = { class = { "Opencpn" } },
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true,
      shape = function()
        return function(cr, w, h)
          gears.shape.rounded_rect(cr, w, h, 8)
        end
      end,
      skip_decoration = true
    }
  }
}
