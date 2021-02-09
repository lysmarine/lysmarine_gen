-- Panels and bars.

local awful = require('awful')
local left_panel = require('layout.left-panel')


-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- Create the left_panel
  s.left_panel = left_panel(s)
end)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      if s.left_panel then
        s.left_panel.visible = not fullscreen
      end
    end
  end
end

_G.tag.connect_signal('property::selected',
  function(t)
    updateBarsVisibility()
  end)

_G.client.connect_signal('property::fullscreen',
  function(c)
    c.screen.selected_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
  end)

_G.client.connect_signal('unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end)
