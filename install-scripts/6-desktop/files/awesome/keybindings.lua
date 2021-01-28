local commands = settings.commands

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- keyboard layout switch
    awful.key({ modkey, }, "z", switch_keyboard_layout),

    awful.key({ }, "Print", function () awful.util.spawn_with_shell(commands.screenshot) end),

    awful.key({ modkey, }, "b", function () toggle_popup_box(mouse.screen.index) end),

    awful.key({ modkey, }, "v", function () toggle_toolbar_box(mouse.screen.index) end),

    -- screenserver lock
    awful.key({ modkey, "Control" }, "l", function () awful.util.spawn_with_shell(commands.screensaver) end),


    -- volume controll
    awful.key({ modkey, }, "Up", function ()
        awful.util.spawn(commands.volumeUp)
        update_volume()
    end),

    awful.key({ modkey, }, "Down", function ()
        awful.util.spawn(commands.volumeDown) 
        update_volume(volume_widget)
    end),
    
    awful.key({  }, "XF86AudioRaiseVolume", function ()
        awful.util.spawn(commands.volumeUp) 
        update_volume(volume_widget)
    end),
    
    awful.key({  }, "XF86AudioLowerVolume", function ()
        awful.util.spawn(commands.volumeDown) 
        update_volume(volume_widget)
    end),
    
    awful.key({  }, "XF86AudioMute", function ()
    awful.util.spawn(commands.volumeMute) end),

    -- Multi screen tag change 

    awful.key({ modkey, "Control"   }, "Right",
      function()
        for i = 1, screen.count() do
          awful.tag.viewnext(i)
        end
      end ),

      awful.key({ modkey, "Control"   }, "Left",
      function()
        for i = 1, screen.count() do
          awful.tag.viewprev(i)
        end
      end ),
    
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.set(awful.layout.suit.tile ) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.set(awful.layout.suit.floating) end),
    awful.key({ modkey, "Shift", "Control"   }, "space", function () awful.layout.set(awful.layout.suit.magnifier) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Promptp
    awful.key({ modkey },            "r",     function () menubar.show() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, }, "c",      function (c) c:kill()                         end),
    -- awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end


root.keys(globalkeys)
