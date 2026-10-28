local wezterm = require 'wezterm'

local function forward_key(key, mods)
  return {
    key = key,
    mods = mods,
    action = wezterm.action.SendKey { key = key, mods = mods },
  }
end

return {
  color_scheme = 'AdventureTime',
  default_prog = { 'herdr' },
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = 'RESIZE',
  keys = {
    forward_key('t', 'CTRL|SHIFT'),
    forward_key('w', 'CTRL|SHIFT'),
    forward_key('Tab', 'CTRL'),
    forward_key('Tab', 'CTRL|SHIFT'),
  },
}
