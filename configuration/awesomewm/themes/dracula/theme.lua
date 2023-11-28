local awful = require("awful")

theme = dofile("/usr/share/awesome/themes/zenburn/theme.lua")

theme.font      = "JetBrains Mono 9"

theme.fg_normal = "#f8f8f2"
theme.fg_focus  = "#EEEEEE"
theme.bg_normal = "#282a36"
theme.bg_focus  = "#6272a4"
theme.bg_urgent = "#ff5555"

theme.border_normal = "#000000"
theme.border_focus  = "#6272a4"
theme.border_width  = "1"

theme.taglist_squares_sel   = awful.util.getdir("config") .. "/themes/dracula/taglist/squarefz.png"
theme.taglist_squares_unsel = awful.util.getdir("config") .. "/themes/dracula/taglist/squarez.png"

theme.menu_width  = 650
theme.tooltip_border_width = 0

return theme
