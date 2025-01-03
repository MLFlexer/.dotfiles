local wezterm = require("wezterm")
local mux = wezterm.mux
wezterm.log_info("The config was reloaded for this window!")

local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
end

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {
	default_workspace = "~",
	font = require("font").font,
	font_rules = require("font").font_rules,
	warn_about_missing_glyphs = false,

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

	max_fps = 120,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
}

if is_windows then
	config.wsl_domains = {
		{
			name = "WSL:NixOS",
			distribution = "NixOS",
			default_cwd = "/home/mlflexer",
		},
	}
	config.default_domain = "WSL:NixOS"
end

config.ssh_domains = {
	{
		name = "rpi5",
		remote_address = "192.168.0.42",
		username = "mlflexer",
	},
}

config.exec_domains = {
	wezterm.exec_domain("rpi5_exec", function(cmd)
		cmd.args = { "ssh", "mlflexer@192.168.0.42" }
		return cmd
	end),
}

-- for host, ssh_config in pairs(wezterm.enumerate_ssh_hosts()) do
-- 	table.insert(config.ssh_domains, {
-- 		name = host,
-- 		remote_address = host,
-- 		multiplexing = "None",
-- 		assume_shell = "Posix",
-- 	})
-- end

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

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.periodic_save({ interval_seconds = 15 * 60, save_workspaces = true, save_windows = true, save_tabs = true })

resurrect.set_encryption({
	enable = true,
	private_key = wezterm.home_dir .. "/.age/resurrect.txt",
	public_key = "age1ddyj7qftw3z5ty84gyns25m0yc92e2amm3xur3udwh2262pa5afqe3elg7",
})

wezterm.on("resurrect.error", function(err)
	wezterm.log_error("ERROR!")
	wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
end)

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- workspace_switcher.apply_to_config(config)
workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = colors.colors.ansi[3] } },
		{ Background = { Color = colors.colors.background } },
		{ Text = "󱂬 : " .. label },
	})
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
	wezterm.log_info(window)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	wezterm.log_info(window)
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
	resurrect.write_current_state(label, "workspace")
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.start", function(window, _)
	wezterm.log_info(window)
end)
wezterm.on("smart_workspace_switcher.workspace_switcher.canceled", function(window, _)
	wezterm.log_info(window)
end)

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "ALT",
	},
})

-- local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
-- config.use_fancy_tab_bar = false
-- tabline.setup({
-- 	sections = {
-- 		tabline_a = {
-- 			"mode",
-- 			"battery",
-- 			"cpu",
-- 			"ram",
-- 			"datetime",
-- 			"hostname",
-- 			"window",
-- 			"workspace",
-- 		},
-- 		tabline_b = {},
-- 		tabline_c = {},
-- 		tab_active = {},
-- 		tab_inactive = {},
-- 		tabline_x = {},
-- 		tabline_y = {},
-- 		tabline_z = {},
-- 	},
-- 	extensions = {
-- 		"resurrect",
-- 		"smart_workspace_switcher",
-- 	},
-- })
--

local domains = wezterm.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")
domains.apply_to_config(config, {
	keys = {
		attach = {
			key = "t",
			mods = "ALT|SHIFT",
			tbl = "",
		},
		vsplit = {
			key = "_",
			mods = "CTRL|ALT",
			tbl = "",
		},
		hsplit = {
			key = "-",
			mods = "CTRL|ALT",
			tbl = "",
		},
	},
	auto = {
		ssh_ignore = true,
		exec_ignore = {
			ssh = true,
			docker = true,
			kubernetes = true,
		},
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

wezterm.on("gui-startup", resurrect.resurrect_on_gui_startup)

return config
