local awful = require("awful")
local naughty = require("naughty")

theme = dofile("/usr/share/awesome/themes/zenburn/theme.lua")

theme.font = "JetBrainsMono 10"

theme.fg_normal = "#CCCCCC"
theme.fg_focus  = "#EEEEEE"
theme.bg_normal = "#222222"
theme.bg_focus  = "#444444"
theme.bg_urgent = "#CC0000"

theme.border_normal = "#000000"
theme.border_focus  = "#ffcb6b"
theme.border_width  = "1"

theme.taglist_squares_sel   = awful.util.getdir("config") .. "/themes/zenburn-mod/taglist/squarefz.png"
theme.taglist_squares_unsel = awful.util.getdir("config") .. "/themes/zenburn-mod/taglist/squarez.png"

theme.menu_width           = 650
theme.tooltip_border_width = 0

theme.notification_bg = "#FFFFFF"
theme.notification_fg = "#000000"
theme.notification_border_color = "#777777"
theme.notification_font = "JetBrains Mono 10"
theme.notification_width = 500
theme.notification_max_width = 500

naughty.config.defaults.border_width = 1
naughty.config.defaults.icon_size = 31
naughty.config.spacing = 5

return theme
