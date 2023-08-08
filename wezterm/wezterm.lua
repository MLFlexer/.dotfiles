local wezterm = require("wezterm")
local mux = wezterm.mux
wezterm.log_info("The config was reloaded for this window!")

local config = {
	-- uncomment if on windows with wsl
	-- default_domain = 'WSL:Ubuntu'

	window_background_opacity = 0.9,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	hide_tab_bar_if_only_one_tab = true,
  hide_mouse_cursor_when_typing = false,
	inactive_pane_hsb = {
		brightness = 0.9,
	},
	scrollback_lines = 5000,
	audible_bell = "Disabled",
	enable_scroll_bar = true,

	status_update_interval = 1000,
}

config.keys = require("keybinds")

-- add smart-split keys
for _, value in ipairs(require("plugins.smart-splits").keys) do
	table.insert(config.keys, value)
end

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
end

local colors = require("colors")
mergeTables(config, colors)

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

return config
