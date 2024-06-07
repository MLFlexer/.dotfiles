local wezterm = require("wezterm")
local mux = wezterm.mux
wezterm.log_info("The config was reloaded for this window!")

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
end

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {
	-- uncomment if on windows with wsl
	-- default_domain = 'WSL:Ubuntu'

	default_workspace = "~",
	font = require("font").font,
	font_rules = require("font").font_rules,

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
	xcursor_theme = "Adwaita", -- fix cursor bug on gnome + wayland
}

local colors = require("colors")
mergeTables(config, colors)

config.leader = { key = "Space", mods = "CTRL|SHIFT", timeout_milliseconds = 1000 }
config.keys = require("keybinds")
config.mouse_bindings = require("mousebinds")

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

wezterm.on("modal.enter", function(name, window, pane)
	modal.set_right_status(window, name)
	modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(name, window, pane)
	local title = basename(window:active_workspace())
	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = title .. "  " },
	}))
	modal.reset_window_title(pane)
end)

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm/")
workspace_switcher.apply_to_config(config)
workspace_switcher.set_workspace_formatter(function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = colors.colors.ansi[3] } },
		{ Background = { Color = colors.colors.background } },
		{ Text = "󱂬: " .. label },
	})
end)

wezterm.on("smart_workspace_switcher.workspace_chosen", function(window, path)
	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
end)

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "ALT",
	},
})

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = " "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("(%d/%d) ", tab.tab_index + 1, #tabs)
	end

	return zoomed .. index .. tab.active_pane.title
end)

for _, value in ipairs(require("plugins.nvim_maximizer").keys) do
	table.insert(config.keys, value)
end

wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	-- window:gui_window():maximize()
end)

return config
