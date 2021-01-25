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

  -- Clock / Calendar 24h format
  local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 11">%H\n%M</span>')
  textclock.forced_height = 46

  -- Add a calendar (credits to kylekewley for the original code)
  local month_calendar = awful.widget.calendar_popup.month({
    screen = s,
    start_sunday = false,
    week_numbers = true
  })
  month_calendar:attach(textclock,'bl')

  local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(0), dpi(8))

  local systray = wibox.widget.systray()
  systray:set_horizontal(false)
  systray:set_base_size(24)

  local menu_icon =
    wibox.widget {
    icon = icons.menu,
    size = dpi(24),
    widget = mat_icon,
    forced_width = dpi(48)
  }

  local home_button =
    wibox.widget {
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

  home_button:buttons(
      awful.button(
        {},
        1,
        nil,
        function()
          panel:toggle()
        end
      )
  )

  local expand_task_list_btn = mat_icon_button(mat_icon(icons.plus, dpi(24)))
  expand_task_list_btn.expanded = false

  expand_task_list_btn:buttons(
      awful.button(
        {},
        1,
        nil,

        function()
          expand_task_list_btn.expanded = not expand_task_list_btn.expanded
          if expand_task_list_btn.expanded then
            static_bar.forced_width = dpi(496)
            static_bar.width = dpi(496)

            panel:open()

          else
            static_bar.forced_width = dpi(48)
            static_bar.width = dpi(48)
            panel.close()
          end

        end
      )
  )
  expand_task_list_btn.height = dpi(24)
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  local LayoutBox = function(s)
    local layoutBox = clickable_container(awful.widget.layoutbox(s))
    layoutBox:buttons(
      awful.util.table.join(
        awful.button(
          {},
          1,
          function()
            awful.layout.inc(1)
          end
        ),
        awful.button(
          {},
          2,
          function()
            awful.layout.inc(0)
          end
        )
      )
    )
    return layoutBox
  end


  panel:connect_signal(
    'opened',
    function()
      menu_icon.icon = icons.close
    end
  )

  panel:connect_signal(
    'closed',
    function()
      menu_icon.icon = icons.menu
    end
  )

  static_bar =  wibox.widget {
    id = 'static_bar',
    layout = wibox.layout.align.vertical,

    forced_width = static_bar_width,
    {
      -- Left widgets
      layout = wibox.layout.fixed.vertical,
      home_button,
      expand_task_list_btn,
      TaskList(screen)
    },
     nil,
    {
      layout = wibox.layout.fixed.vertical,
      wibox.container.margin(systray, dpi(10), dpi(10)),
      LayoutBox(screen),
      clock_widget
    }
  }
  return static_bar

end
