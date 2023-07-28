local wezterm = require("wezterm")
local nf = wezterm.nerdfonts

local SOLID_LEFT_ROUND = nf.ple_left_half_circle_thick
local SOLID_RIGHT_ROUND = nf.ple_right_half_circle_thick

local THIN_LEFT_ROUND = nf.ple_left_half_circle_thin
local THIN_RIGHT_ROUND = nf.ple_right_half_circle_thin

local NERD_NUMS = {
	nf.md_numeric_1,
	nf.md_numeric_2,
	nf.md_numeric_3,
	nf.md_numeric_4,
	nf.md_numeric_5,
	nf.md_numeric_6,
	nf.md_numeric_7,
	nf.md_numeric_8,
	nf.md_numeric_9,
	nf.md_numeric_10,
}

local function get_thick_num(i)
	if i > 0 and i <= 10 then
		return NERD_NUMS[i] .. " "
	end
	return ""
end

local function get_nerd_title(title)
	if title == "nvim" or title == "vim" then
		return nf.custom_vim
	elseif title == "zsh" then
		return nf.dev_terminal_badge
	end
	return title
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return get_nerd_title(tab_info.active_pane.title)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local color_scheme = config.resolved_palette
	local edge_background = color_scheme.background
	local edge_foreground = color_scheme.tab_bar.active_tab.fg_color --color_scheme.foreground
	local background = color_scheme.background
	local foreground = color_scheme.tab_bar.active_tab.fg_color
	-- color_scheme.tab_bar.inactive_tab.fg_color

	local left_bar = THIN_LEFT_ROUND
	local right_bar = THIN_RIGHT_ROUND

	if tab.is_active then
		foreground = color_scheme.tab_bar.active_tab.bg_color
		background = color_scheme.tab_bar.active_tab.fg_color
		edge_foreground = color_scheme.tab_bar.active_tab.fg_color
		left_bar = SOLID_LEFT_ROUND
		right_bar = SOLID_RIGHT_ROUND
	elseif hover then
		foreground = color_scheme.tab_bar.inactive_tab_hover.bg_color
		background = color_scheme.tab_bar.inactive_tab_hover.fg_color
		edge_foreground = color_scheme.tab_bar.inactive_tab_hover.fg_color
		right_bar = SOLID_RIGHT_ROUND
		left_bar = SOLID_LEFT_ROUND
	end

	local title = get_thick_num(tab.tab_index + 1) .. tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_bar },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = right_bar },
	}
end)

return {}
