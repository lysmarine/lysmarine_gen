
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)),

root.buttons(awful.util.table.join(
    awful.button({ }, 3, toogle_main_menu),
    awful.button({ }, 2, function ()  toggle_popup_box(mouse.screen) end)
-- Disabled for the sake of humanity
--    awful.button({ }, 4, awful.tag.viewnext),
--    awful.button({ }, 5, awful.tag.viewprev)
))
