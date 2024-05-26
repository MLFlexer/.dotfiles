local wezterm = require("wezterm")
local act = wezterm.action
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")

local keys = {
	{
		key = "g",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			local current_tab_id = pane:tab():tab_id()
			local cmd = "lazygit ; wezterm cli activate-tab --tab-id " .. current_tab_id .. " ; exit\n"
			local tab, tab_pane, _ = window:mux_window():spawn_tab({})
			tab_pane:send_text(cmd)
			tab:set_title(wezterm.nerdfonts.dev_git .. " Lazygit")
		end),
	},
	{
		key = "-",
		mods = "ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 30 },
		}),
	},
	{
		key = "_",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 25 },
		}),
	},
	{
		key = "z",
		mods = "ALT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "o",
		mods = "ALT",
		action = wezterm.action.ActivateLastTab,
	},
	{
		key = "t",
		mods = "ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "p",
		mods = "ALT",
		action = act.PaneSelect({}),
	},
	{
		key = "p",
		mods = "ALT|SHIFT",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		key = "d",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(
				act.SwitchToWorkspace({
					name = ".dotfiles",
					spawn = { cwd = wezterm.home_dir .. "/repos/.dotfiles" },
				}),
				pane
			)
			window:set_right_status(window:active_workspace())
		end),
	},
	{
		key = "e",
		mods = "LEADER",
		action = wezterm.action.CharSelect({
			copy_on_select = true,
			copy_to = "ClipboardAndPrimarySelection",
		}),
	},
	{
		key = "m",
		mods = "ALT",
		action = wezterm.action.Multiple({
			wezterm.action.ActivateKeyTable({
				name = "UI",
				one_shot = false,
			}),
			wezterm.action_callback(function(win, pane)
				local conf = win:get_config_overrides()
				if conf == nil then
					conf = { hide_tab_bar_if_only_one_tab = true }
				else
					conf.hide_tab_bar_if_only_one_tab = not conf.hide_tab_bar_if_only_one_tab
				end

				win:set_config_overrides(conf)
			end),
		}),
	},
	-- {
	-- 	key = "m",
	-- 	mods = "ALT",
	-- 	action = act.Multiple({
	-- 		wezterm.action_callback(function(win, pane)
	-- 			pane:inject_output("\x1b]2;new_title\x1b\\")
	-- 		end),
	-- 	}),
	-- },
	{ key = "L", mods = "CTRL|SHIFT|ALT", action = wezterm.action.ShowDebugOverlay },

	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_tab()
		end),
	},
	{
		key = "N",
		mods = "LEADER | SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_window()
		end),
	},
}

local function tab_switch_keys(key_table, modifier)
	for i = 1, 9 do
		table.insert(key_table, {
			key = tostring(i),
			mods = modifier,
			action = act.ActivateTab(i - 1),
		})
	end
	table.insert(key_table, {
		key = "0",
		mods = modifier,
		action = act.ActivateTab(9),
	})
end

tab_switch_keys(keys, "ALT")

return keys
