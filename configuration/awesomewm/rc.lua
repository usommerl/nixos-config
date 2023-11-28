local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

awful.util.shell = "bash"

-- {{{ Custom functions

function dbug(message)
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = 'Debug',
    text = tostring(message) })
end

function hideBordersIfNecessary(client)
   hideBordersIfMaximized(client)
   hideBordersIfOnlyOneClientVisible()
end

function hideBordersIfOnlyOneClientVisible()
  local visibleClients = awful.client.visible(mouse.screen)
  if #visibleClients == 1 then
      local client = visibleClients[1]
      hideBorders(client)
  end
end

function hideBordersIfMaximized(client)
  if client.maximized_vertical and client.maximized_horizontal then
      hideBorders(client)
  else
      client.border_color = theme.border_focus
  end
end

function hideBordersDelayed(client)
  local hideTimer = gears.timer({ timeout = 0.5 })
  hideTimer:connect_signal("timeout",
    function()
      client.border_color = theme.border_normal
      hideTimer:stop()
    end)
  hideTimer:start()
end

function hideBorders(client)
  if lastScreen == client.screen then
      client.border_color = theme.border_normal
  else
      hideBordersDelayed(client)
  end
end

function menu_center_coords(numberOfMenuItems)
   local s_geometry = screen[mouse.screen].workarea
   local menu_height = numberOfMenuItems * theme.menu_height +  2 * theme.border_width
   local menu_x = (s_geometry.width - theme.menu_width) / 2 + s_geometry.x
   local menu_y = (s_geometry.height - menu_height ) / 2 + s_geometry.y - 100
   return {["x"] = menu_x, ["y"] = menu_y}
end

function minimized_clients_selector(clients)
  local menuItems = {}
  for _, c in pairs(clients) do
      table.insert(menuItems,
                   {c.name,
                    function()
                        if not client_tag_visible(c) then
                            awful.tag.viewonly(c:tags()[1])
                        end
                        client.focus = c
                        c:raise()
                        -- For a short period after client.focus the number
                        -- of visible clients is 0. Therefore the
                        -- hideBordersIfOnlyOneClientVisible()
                        -- method fails in this particular case.
                        if (#awful.client.visible(mouse.screen) == 0) then
                            hideBorders(c)
                        end
                    end
                   })
  end
  awful.menu(menuItems):show({coords = menu_center_coords(table_length(menuItems) - 1)})
end

function all_minimized_clients()
  local clients = {}
  for i, c in pairs(client.get(mouse.screen)) do
    if c.minimized then
      table.insert(clients,c)
    end
  end
  return clients
end

function client_tag_visible(client)
  for _, t1 in pairs(client:tags()) do
    for _, t2 in pairs(awful.tag.selectedlist(mouse.screen)) do
      if t1 == t2 then
        return true
      end
    end
  end
  return false
end

function show_all_minimized_clients()
  minimized_clients_selector(all_minimized_clients())
end

function show_minimized_clients_on_tag()
  local clients = {}
  for _, c in pairs(all_minimized_clients()) do
    if client_tag_visible(c) then
        table.insert(clients,c)
    end
  end
  minimized_clients_selector(clients)
end

function table_length(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

function effectivePower()
  local rate
  local power_nowFile = io.open("/sys/class/power_supply/BAT0/power_now", "rb")
  if power_nowFile then
    rate = power_nowFile:read() / 10^6
    power_nowFile:close()
  else
    local current_nowFile = io.open("/sys/class/power_supply/BAT0/current_now", "rb")
    local voltage_nowFile = io.open("/sys/class/power_supply/BAT0/voltage_now", "rb")
    local current_now = current_nowFile:read()
    current_nowFile:close()
    local voltage_now = voltage_nowFile:read()
    voltage_nowFile:close()
    rate = (voltage_now * current_now) / 10^12
  end
  return rate
end

math.round = function(number, precision)
  precision = precision or 0
  local decimal = string.find(tostring(number), ".", nil, true);
  if (decimal) then
    local power = 10 ^ precision;
    if ( number >= 0 ) then
      number = math.floor(number * power + 0.5) / power;
    else
      number = math.ceil(number * power - 0.5) / power;
    end
    -- convert number to string for formatting
    number = tostring(number);
    -- set cutoff
    local cutoff = number:sub(decimal + 1 + precision);
    -- delete everything after the cutoff
    number = number:gsub(cutoff, "");
  else
    -- number is an integer
    if ( precision > 0 ) then
      number = tostring(number);
      number = number .. ".";
      for i = 1,precision
      do
          number = number .. "0";
      end
    end
  end
  return number;
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "\n" ) .. "}"
end

-- starts a terminal in the current working directory
-- update the working directory in your zsh precmd hook
function startTerminal()
    local home = os.getenv("HOME")
    local file = io.open(home .. "/.terminal_start_directory", "r")
    if file then
        local directory = file:read()
        if directory then
            awful.spawn(terminal .. " --working-directory " .. directory)
            return
        end
    end
    awful.spawn(terminal)
end

-- resets the terminal working directory at awesome startup
function resetTerminalStartDirectory()
    awful.spawn.with_shell("echo $HOME > $HOME/.terminal_start_directory")
end
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
                   title = "Oops, there were errors during startup!",
                   text = awesome.startup_errors })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, an error happened!",
                     text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
beautiful.init(awful.util.getdir("config") .. "/themes/zenburn-mod/theme.lua")
terminal = "alacritty"
rofiRunCommand = "rofi -no-disable-history -combi-modi window,run,ssh -show combi -modi combi"
rofiClipboardCommand = [[
  BEFORE="$(xclip -o -selection clipboard)"
  rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
  sleep 0.1
  AFTER="$(xclip -o -selection clipboard)"
  if [ "${AFTER}" != "${BEFORE}" ]; then
    xdotool key ctrl+shift+v
  fi
]]

modkey = "Mod4"
lastScreen = 1

awful.layout.layouts = {
  -- awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Wibar
mytextclock = wibox.widget.textclock("%Y-%m-%dT%H:%M:%S%z", 1)

function spacer(width)
  return wibox.widget { background_color  = theme.bg_normal,
                        widget            = wibox.widget.progressbar,
                        forced_width      = width }
end

width_progressbar = 8

function batteryWidgetFormatter(container, data)
  local widget = container.widget
  widget:set_value(data[2])

  if data[2] >= 40 and data[2] <= 100 then
    widget.color = theme.bg_focus
  elseif data[2] >= 15 and data[2] < 40 then
    widget.color = '#FFCC00'
  elseif data[2] >= 0  and data[2] < 15 then
    widget.color = '#CC0000'
    if data[2] <= 3 and data[1] == "−" then
      awful.spawn.easy_async_with_shell('acpi -b | sed "s/Battery 0: //"',
        function(stdout, stderr, exitreason, exitcode)
          naughty.notify({ preset = naughty.config.presets.critical,
                           title = "Battery critical",
                           timeout = 10,
                           text =  string.gsub(stdout , "%s*$", "") })
        end)
    end
  end

  if data[1] == "+" then
    widget.border_width = 1.8
    widget.border_color = '#004000'
  else
    widget.border_width = 0
  end
  return data[2]
end

local batteryWidget = wibox.widget {
  {
    max_value         = 100,
    ticks             = true,
    ticks_size        = 1,
    ticks_gap         = 1,
    background_color  = theme.bg_normal,
    color             = theme.bg_focus,
    widget            = wibox.widget.progressbar,
  },
  forced_width  = width_progressbar,
  direction     = 'east',
  layout        = wibox.container.rotate,
}

vicious.register(batteryWidget, vicious.widgets.bat, batteryWidgetFormatter, 60, "BAT0")

local batteryWidgetTooltip = awful.tooltip({
  objects = { batteryWidget },
  mode = 'outside',
  timer_function = function()
    awful.spawn.easy_async_with_shell('acpi -a -b -i',
      function(stdout, stderr, exitreason, exitcode)
        setBatteryWidgetTooltipText(string.gsub(stdout , "%s*$", ""))
      end)
  end
})

function setBatteryWidgetTooltipText(acpiResult)
  if string.find(acpiResult, "Adapter 0: off") ~= nil then
    batteryWidgetTooltip.text = "Battery 0: effective power consumption " .. math.round(effectivePower(), 1) .. " W\n" .. acpiResult
  else
    batteryWidgetTooltip.text = acpiResult
  end
end

function wifiWidgetFormatter(container, data)
  local widget = container.widget
  widget:set_value(data['{linp}'])
end

local wifiWidget = wibox.widget {
  {
    max_value         = 100,
    ticks             = true,
    ticks_size        = 1,
    ticks_gap         = 1,
    background_color  = theme.bg_normal,
    color             = theme.bg_focus,
    widget            = wibox.widget.progressbar,
  },
  forced_width  = width_progressbar,
  direction     = 'east',
  layout        = wibox.container.rotate,
}

wlanInterface = io.popen("find /sys/class/net -type l -execdir basename '{}' ';' | grep '^w.*'"):read("*all")
vicious.register(wifiWidget, vicious.widgets.wifi, wifiWidgetFormatter, 15, wlanInterface)

local wifiWidgetTooltip = awful.tooltip({
  objects = { wifiWidget },
  mode = 'outside',
  timer_function = function()
    awful.spawn.easy_async_with_shell('connectionStatus.sh',
      function(stdout, stderr, exitreason, exitcode)
        setWifiWidgetTooltipText(string.gsub(stdout , "%s*$", ""))
      end)
  end
})

function setWifiWidgetTooltipText(connectionStatus)
  wifiWidgetTooltip.text = connectionStatus
end

local taglist_buttons = awful.util.table.join(
  awful.button({        }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
                                if client.focus then
                                    client.focus:move_to_tag(t)
                                end
                              end),
  awful.button({        }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
                                if client.focus then
                                    client.focus:toggle_tag(t)
                                end
                              end),
  awful.button({        }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({        }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local function set_wallpaper(s)
  local pattern = gears.color.create_solid_pattern(theme.bg_normal)
  gears.wallpaper.set(pattern)
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  s.mypromptbox = awful.widget.prompt()
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
  s.mywibox = awful.wibar({ position = "top", screen = s })

  s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        batteryWidget,
        spacer(3),
        wifiWidget,
        spacer(3),
        s.mytaglist,
        s.mypromptbox,
      },
      {
        layout = wibox.layout.fixed.horizontal
      },
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.systray(),
        mytextclock,
      },
  }

  s.mywibox.visible = false
  s.mywibox.ontop = true

  --awful.spawn.easy_async_with_shell('xrandr | grep " connected " | grep "HDMI2"',
    --function(stdout, stderr, exitreason, exitcode)
      --if (stdout == nil or stdout == '') then
        --s:fake_resize(228, 0, 1138, 768)
      --end
    --end)
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey, "Control"              }, "r",          awesome.restart),
  awful.key({ modkey, "Shift"                }, "q",          awesome.quit),
  awful.key({ modkey,                        }, "Escape",     awful.tag.history.restore),
  awful.key({ modkey,                        }, "u",          awful.client.urgent.jumpto),
  awful.key({ modkey, "Control"              }, "n",          function () awful.spawn.with_shell("rofi_wm_hidden_clients")                       end),
  awful.key({ modkey,                        }, "Return",     startTerminal),
  awful.key({ modkey, "Shift"                }, "Return",     function () awful.util.spawn(terminal)                                             end),
  awful.key({ modkey,                        }, "j",          function () awful.client.focus.byidx( 1)                                           end),
  awful.key({ modkey,                        }, "k",          function () awful.client.focus.byidx(-1)                                           end),
  awful.key({ modkey, "Shift"                }, "j",          function () awful.client.swap.byidx(  1)                                           end),
  awful.key({ modkey, "Shift"                }, "k",          function () awful.client.swap.byidx( -1)                                           end),
  awful.key({ modkey, "Mod1"                 }, "h",          function () awful.screen.focus_bydirection("left")                                 end),
  awful.key({ modkey, "Mod1"                 }, "l",          function () awful.screen.focus_bydirection("right")                                end),
  awful.key({ modkey,                        }, "l",          function () awful.tag.incmwfact( 0.05)                                             end),
  awful.key({ modkey,                        }, "h",          function () awful.tag.incmwfact(-0.05)                                             end),
  awful.key({ modkey, "Shift"                }, "h",          function () awful.tag.incnmaster( 1, nil, true)                                    end),
  awful.key({ modkey, "Shift"                }, "l",          function () awful.tag.incnmaster(-1, nil, true)                                    end),
  awful.key({ modkey, "Control"              }, "h",          function () awful.tag.incncol( 1, nil, true)                                       end),
  awful.key({ modkey, "Control"              }, "l",          function () awful.tag.incncol(-1, nil, true)                                       end),
  awful.key({ modkey,                        }, "space",      function () awful.layout.inc( 1)                                                   end),
  awful.key({ modkey, "Shift"                }, "space",      function () awful.layout.inc(-1)                                                   end),
  awful.key({                                }, "#122",       function () awful.spawn.with_shell("pactl -- set-sink-volume @DEFAULT_SINK@ -1%")  end),
  awful.key({ modkey                         }, "-",          function () awful.spawn.with_shell("pactl -- set-sink-volume @DEFAULT_SINK@ -1%")  end),
  awful.key({                                }, "#123",       function () awful.spawn.with_shell("pactl -- set-sink-volume @DEFAULT_SINK@ +1%")  end),
  awful.key({ modkey                         }, "+",          function () awful.spawn.with_shell("pactl -- set-sink-volume @DEFAULT_SINK@ +1%")  end),
  awful.key({ modkey, "Shift"                }, "m",          function () awful.spawn.with_shell("pactl -- set-sink-mute @DEFAULT_SINK@ toggle") end),
  awful.key({ modkey                         }, "b",          function () mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible        end),
  awful.key({ modkey                         }, "F7",         function () awful.spawn.with_shell("sleep 1; xset s activate")                     end),
  awful.key({ modkey                         }, "End",        function () awful.spawn.with_shell("i3lock -c 000000")                             end),
  awful.key({ modkey, "Shift"                }, "End",        function () awful.spawn.with_shell("systemctl suspend")                            end),
  awful.key({ modkey                         }, "Pause",      function () awful.spawn.with_shell("i3lock -c 000000")                             end),
  awful.key({ modkey, "Shift"                }, "Pause",      function () awful.spawn.with_shell("systemctl suspend")                            end),
  awful.key({ modkey                         }, "p",          function () awful.spawn.with_shell("ncmpcpp toggle")                               end),
  awful.key({ modkey, "Shift", "Control"     }, "s",          function () awful.spawn.with_shell("poweroff")                                     end),
  awful.key({ modkey,                        }, "v",          function () awful.spawn.with_shell(rofiClipboardCommand) end),
  awful.key({ modkey,                        }, "r",          function () awful.spawn.with_shell(rofiRunCommand) end)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey, "Control"              }, "space",      awful.client.floating.toggle),
  awful.key({ modkey, "Shift"                }, "c",          function (c) c:kill()                                                          end),
  awful.key({ modkey, "Control"              }, "Return",     function (c) c:swap(awful.client.getmaster())                                  end),
  awful.key({ modkey,                        }, "o",          function (c) c:move_to_screen()                                                end),
  awful.key({ modkey,                        }, "t",          function (c) c.sticky = not c.sticky                                           end),
  awful.key({ modkey,                        }, "n",          function (c) c.minimized = true                                                end),
  awful.key({ modkey,                        }, "m",          function (c)
                                                                  c.maximized = not c.maximized
                                                                  c:raise()
                                                              end),
  awful.key({ modkey,                        }, "f",          function (c)
                                                               c.fullscreen = not c.fullscreen
                                                               c:raise()
                                                              end)
)

for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
      -- View tag only.
      awful.key({ modkey                     }, "#" .. i + 9, function ()
                                                                    local screen = awful.screen.focused()
                                                                    local tag = screen.tags[i]
                                                                    if tag then
                                                                       tag:view_only()
                                                                    end
                                                              end),
      -- Toggle tag display.
      awful.key({ modkey, "Control"          }, "#" .. i + 9, function ()
                                                                  local screen = awful.screen.focused()
                                                                  local tag = screen.tags[i]
                                                                  if tag then
                                                                     awful.tag.viewtoggle(tag)
                                                                  end
                                                              end),
      -- Move client to tag.
      awful.key({ modkey, "Shift"            }, "#" .. i + 9, function ()
                                                                  if client.focus then
                                                                      local tag = client.focus.screen.tags[i]
                                                                      if tag then
                                                                          client.focus:move_to_tag(tag)
                                                                      end
                                                                 end
                                                              end),
      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
                                                                  if client.focus then
                                                                      local tag = client.focus.screen.tags[i]
                                                                      if tag then
                                                                          client.focus:toggle_tag(tag)
                                                                      end
                                                                  end
                                                              end)
  )
end

clientbuttons = awful.util.table.join(
  awful.button({                            }, 1,             function (c) client.focus = c; c:raise() end),
  awful.button({ modkey                     }, 1,             awful.mouse.client.move),
  awful.button({ modkey                     }, 3,             awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   border_color = beautiful.border_normal,
                   focus = awful.client.focus.filter,
                   raise = true,
                   keys = clientkeys,
                   buttons = clientbuttons,
                   screen = awful.screen.preferred,
                   placement = awful.placement.no_overlap+awful.placement.no_offscreen
   }
  },

  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
      },
      class = {
        "Arandr",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "xtightvncviewer"},

      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    }, properties = { floating = true }},

  { rule_any = {type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = false }
  },
  { rule = { class = "URxvt" },
    properties = { size_hints_honor = false } },
}
-- }}}

-- {{{ Signals
client.connect_signal("manage", function (c)
  if awesome.startup and
    not c.size_hints.user_position and
    not c.size_hints.program_position then
      awful.placement.no_offscreen(c)
  end
end)

client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus"  , function(c)
                                   c.border_color = beautiful.border_focus
                                  hideBordersIfNecessary(c)
                                 end)
client.connect_signal("unfocus", function(c)
                                   lastScreen = c.screen
                                   c.border_color = beautiful.border_normal
                                 end)

client.connect_signal("property::maximized_horizontal", function(c) hideBordersIfNecessary(c) end)
client.connect_signal("property::maximized_vertical"  , function(c) hideBordersIfNecessary(c) end)
screen.connect_signal("removed", awesome.restart)
screen.connect_signal("added", awesome.restart)
-- }}}

-- {{{ Execute on startup/restart
resetTerminalStartDirectory()
-- }}}
