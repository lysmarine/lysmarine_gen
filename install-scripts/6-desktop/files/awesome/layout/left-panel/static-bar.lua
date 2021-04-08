local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local mat_icon = require('widget.material.icon')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('theme.icons')
local clickable_container = require('widget.material.clickable-container')
local TaskList = require('widget.task-list')
local mat_icon_button = require('widget.material.icon-button')
local filesystem = require('gears.filesystem')

return function(screen, panel, static_bar_width)

  local menu_icon = wibox.widget {
    icon = icons.menu,
    size = dpi(24),
    widget = mat_icon,
    forced_width = dpi(48)
  }

  local taskbar_icon = wibox.widget {
    icon = icons.winclose,
    size = dpi(24),
    widget = mat_icon,
    forced_width = dpi(48)
  }



  -- Create the home button to toggle the left collapsible part
  local home_button = wibox.widget {
    wibox.widget {
      menu_icon,
      widget = clickable_container,
      forced_height = dpi(48),
      forced_width = dpi(48)
    },
    bg = beautiful.primary.hue_500,
    widget = wibox.container.background,
    forced_width = dpi(48)
  }

  -- Connect action to the button
  home_button:buttons(awful.button({},
    1,
    nil,
    function()
      panel:toggle()
    end))



  -- Create the task button to toggle the right collapsible part
  local expand_task_list_btn =
  wibox.widget {
    wibox.widget {
      taskbar_icon,
      widget = clickable_container,
      forced_height = dpi(48),
      forced_width = dpi(48),
    },
    widget = wibox.container.background,
    forced_width = dpi(48)
  }

  -- Connect action to the button
  expand_task_list_btn:buttons(-- The table of buttons that should bind to the widget.
    awful.button(-- awful.button:new (mod, _button, press, release)
      { height = dpi(24), expanded = false },
      1,
      nil,
      function()
        expand_task_list_btn.expanded = not expand_task_list_btn.expanded
        if expand_task_list_btn.expanded then
          taskbar_icon.visible = false
          static_bar.forced_width = dpi(496)
          static_bar.width = dpi(496)
          -- expand_task_list_btn.bg = beautiful.primary.hue_500,
          panel:open()

        else
          taskbar_icon.visible = true
          static_bar.forced_width = dpi(48)
          static_bar.width = dpi(48)
          expand_task_list_btn.bg = nil,
          panel:close()
        end
      end))



  -- Clock / Calendar 24h format
  local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 11">%H\n%M</span>')
  textclock.forced_height = 46

  -- Add a calendar (credits to kylekewley for the original code)
  local month_calendar = awful.widget.calendar_popup.month({
    screen = s,
    start_sunday = false,
    week_numbers = true
  })
  month_calendar:attach(textclock, 'bl')

  local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(0), dpi(13))

  local systray = wibox.widget.systray()
  systray:set_horizontal(false)
  systray:set_base_size(24)

  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  local LayoutBox = function(s)
    local layoutBox = clickable_container(awful.widget.layoutbox(s))
    layoutBox:buttons(awful.util.table.join(awful.button({},
      1,
      function()
        awful.layout.inc(1)
      end),
      awful.button({},
        2,
        function()
          awful.layout.inc(0)
        end)))
    return layoutBox
  end

  panel:connect_signal('opened',
    function()
      menu_icon.icon = icons.close
    end)

  panel:connect_signal('closed',
    function()
      menu_icon.icon = icons.menu
      taskbar_icon.visible = true
      expand_task_list_btn.bg = nil
      expand_task_list_btn.expanded = false
    end)

  static_bar = wibox.widget {
    id = 'static_bar',
    layout = wibox.layout.align.vertical,
    forced_width = static_bar_width,
    {
      layout = wibox.layout.fixed.vertical,
      home_button,
      expand_task_list_btn,
      TaskList(screen)
    },
    nil,
    {
      layout = wibox.layout.fixed.vertical,
      wibox.container.margin(systray, dpi(13), dpi(13), dpi(13), dpi(0)),
      LayoutBox(screen),
      clock_widget
    }
  }
  return static_bar
end
