local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'FiraCode Nerd Font'
-- config.font = wezterm.font 'Mononoki Nerd Font'
config.font_size = 15.0

-- config.color_scheme = 'Default Dark (base16)'
config.color_scheme = "Catppuccin Mocha"

config.window_background_opacity = 0.90
-- config.text_background_opacity = 0.0
config.macos_window_background_blur = 20

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.enable_tab_bar = false

return config
