local wezterm = require("wezterm")
local config = {
	font = wezterm.font("MesloLGLDZ Nerd Font Mono"),
	font_size = 12.0,

	color_scheme = "tokyonight_storm",
	window_background_opacity = 0.9,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	hide_tab_bar_if_only_one_tab = true,
}

return config
