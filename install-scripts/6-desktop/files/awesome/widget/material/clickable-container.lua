local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

function build(widget)
  local the_bg = wibox.container.background

  local container =
  wibox.widget {
    widget,
    widget = the_bg,
    forced_height = dpi(48),
    forced_width = dpi(48),
    width = dpi(48),
  }
  local old_cursor, old_wibox

  container:connect_signal('mouse::enter',
    function()
      container.bg = '#ffffff11'
      -- Hm, no idea how to get the wibox from this signal's arguments...
      local w = _G.mouse.current_wibox
      if w then
        old_cursor, old_wibox = w.cursor, w
        w.cursor = 'arrow'
      end
    end)

  container:connect_signal('mouse::leave',
    function()
      container.bg = '#ffffff00'
      if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
      end
    end)

  container:connect_signal('button::press',
    function()
      container.bg = '#ffffff22'
    end)

  container:connect_signal('button::release',
    function()
      container.bg = '#ffffff11'
    end)

  return container
end

return build
