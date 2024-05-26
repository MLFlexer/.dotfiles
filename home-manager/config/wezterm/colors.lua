local wezterm = require("wezterm")
local color_scheme = wezterm.color.get_builtin_schemes()["tokyonight_storm"]
local colors = wezterm.color.get_builtin_schemes()["tokyonight_storm"]
colors.tab_bar.new_tab.bg_color = color_scheme.tab_bar.inactive_tab.bg_color
colors.tab_bar.background = color_scheme.background
colors.tab_bar.active_tab.fg_color = color_scheme.tab_bar.active_tab.bg_color
colors.tab_bar.active_tab.bg_color = color_scheme.tab_bar.active_tab.fg_color
colors.tab_bar.active_tab.fg_color = color_scheme.tab_bar.active_tab.bg_color
colors.tab_bar.active_tab.bg_color = color_scheme.tab_bar.active_tab.fg_color
colors.tab_bar.inactive_tab_hover.bg_color = color_scheme.selection_bg
colors.tab_bar.inactive_tab_edge = color_scheme.selection_bg

return {
	window_frame = {
		inactive_titlebar_bg = color_scheme.background,
		active_titlebar_bg = color_scheme.background,
		inactive_titlebar_fg = color_scheme.foreground,
		active_titlebar_fg = color_scheme.foreground,
	},
	command_palette_bg_color = color_scheme.background,
	command_palette_fg_color = color_scheme.foreground,
	char_select_bg_color = color_scheme.background,
	char_select_fg_color = color_scheme.tab_bar.active_tab.fg_color,
	colors = colors,
}

-- color_scheme = {
-- foreground: #c0caf5,
-- background: #24283b,
-- ansi: [
--     #1d202f,
--     #f7768e,
--     #9ece6a,
--     #e0af68,
--     #7aa2f7,
--     #bb9af7,
--     #7dcfff,
--     #a9b1d6,
-- ],
-- brights: [
--     #414868,
--     #f7768e,
--     #9ece6a,
--     #e0af68,
--     #7aa2f7,
--     #bb9af7,
--     #7dcfff,
--     #c0caf5,
-- ],
-- cursor_fg: #24283b,
-- cursor_bg: #c0caf5,
-- cursor_border: #c0caf5,
-- selection_bg: #364a82,
-- selection_fg: #c0caf5,
-- tab_bar: {
--     background: #191b28,
--     active_tab: {
--         bg_color: #24283b,
--         fg_color: #7aa2f7,
--         intensity: Normal,
--         italic: false,
--         strikethrough: false,
--         underline: None,
--     },
--     inactive_tab: {
--         bg_color: #1f2335,
--         fg_color: #545c7e,
--         intensity: Normal,
--         italic: false,
--         strikethrough: false,
--         underline: None,
--     },
--     inactive_tab_edge: #1f2335,
--     inactive_tab_hover: {
--         bg_color: #1f2335,
--         fg_color: #7aa2f7,
--         intensity: Normal,
--         italic: false,
--         strikethrough: false,
--         underline: None,
--     },
--     new_tab: {
--         bg_color: #191b28,
--         fg_color: #7aa2f7,
--         intensity: Normal,
--         italic: false,
--         strikethrough: false,
--         underline: None,
--     },
--     new_tab_hover: {
--         bg_color: #7aa2f7,
--         fg_color: #1f2335,
--         intensity: Normal,
--         italic: false,
--         strikethrough: false,
--         underline: None,
--     },
-- }
-- }
