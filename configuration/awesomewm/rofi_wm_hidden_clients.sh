#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly lua_minimized_clients=$(cat <<EOF
function minimized_clients()
  local clients = {}
  for i, c in pairs(client.get(mouse.screen)) do
    if c.minimized then
      table.insert(clients,c)
    end
  end
  return clients
end
EOF
)

readonly lua_list_minized_clients=$(cat <<EOF
$lua_minimized_clients
function list(clients)
  local result = ""
  for i, c in pairs(clients) do
    result = result .. i .. " " .. c.name .. "\n"
  end
  return result
end

return list(minimized_clients())
EOF
)

readonly lua_raise_client=$(cat <<EOF
local awful = require("awful")
local gears = require("gears")
$lua_minimized_clients
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

function raise_client(index)
  local c = minimized_clients()[index]
  if not client_tag_visible(c) then
    awful.tag.viewonly(c:tags()[1])
  end
  client.focus = c
  c:raise()
  if (#awful.client.visible(mouse.screen) == 0) then
    hideBorders(c)
  end
end
EOF
)

main() {
  local client_list="$(awesome-client "$lua_list_minized_clients" \
    | sed -e 's/^\s\+string "//' -e '/^"$/d')"

  if [ -z "$client_list" ]; then exit 0; fi
  local selected="$(echo "$client_list" \
                      | rofi -dmenu -p 'minimized clients' \
                      | cut -d ' ' -f 1)"

  if [ -z "$selected" ]; then exit 0; fi
  awesome-client "$lua_raise_client return raise_client($selected)"
}

main
exit 0
