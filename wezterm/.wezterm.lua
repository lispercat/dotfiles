local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local config = wezterm.config_builder()
config.color_scheme = 'Catppuccin Mocha'

-- Session manager integration
local session_manager = require("wezterm-session-manager/session-manager")
wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

-- Key bindings
config.keys = {
  { key = "t", mods = "CTRL|SHIFT", action = act.SpawnCommandInNewTab { args = { "wsl" } } },
  { key = "S", mods = "LEADER", action = wezterm.action{EmitEvent = "save_session"} },
  { key = "L", mods = "LEADER", action = wezterm.action{EmitEvent = "load_session"} },
  { key = "R", mods = "LEADER", action = wezterm.action{EmitEvent = "restore_session"} },
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
}

-- WSL domain setup
config.wsl_domains = {
  {
    name = "WSL:Ubuntu",
    distribution = "Ubuntu",
  },
}
config.default_domain = "WSL:Ubuntu"

return config

