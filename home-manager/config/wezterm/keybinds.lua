local wezterm = require("wezterm")
local act = wezterm.action
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local keys = {
	{
		key = "s",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	},
	{
		key = "S",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	},
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
		key = "y",
		mods = "CTRL",
		action = wezterm.action.AttachDomain("local"),
	},
	{
		key = "Y",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DetachDomain("CurrentPaneDomain"),
	},
	{
		key = "b",
		mods = "ALT",
		action = resurrect.tab_state.save_tab_action(), --wezterm.action_callback(function(win, pane)
		-- local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
		-- resurrect.window_state.save_window_action(),
		-- wezterm.log_info(pane:get_foreground_process_info())
		-- wezterm.log_info(pane:get_lines_as_text())
		-- wezterm.reload_configuration()
		-- end),
	},
	{
		key = "v",
		mods = "ALT",
		action = wezterm.action.Multiple({
			wezterm.action_callback(function(win, pane)
				pane:tab():set_title("SET FROM ALT V")
				wezterm.log_info(pane:get_foreground_process_info())
				wezterm.log_info(pane:get_lines_as_text())
				-- wezterm.reload_configuration()
			end),
		}),
	},
	-- {
	-- 	key = "l",
	-- 	mods = "ALT",
	-- 	action = wezterm.action_callback(function(win, pane)
	-- 		local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
	-- 		resurrect.fuzzy_load(win, pane, function(id, label)
	-- 			local type = string.match(id, "^([^/]+)") -- match before '/'
	-- 			id = string.match(id, "([^/]+)$") -- match after '/'
	-- 			id = string.match(id, "(.+)%..+$") -- remove file extention
	-- 			local state
	-- 			if type == "workspace" then
	-- 				state = resurrect.load_state(id, "workspace")
	-- 				resurrect.workspace_state.restore_workspace(state, {
	-- 					relative = true,
	-- 					restore_text = true,
	-- 					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	-- 				})
	-- 			elseif type == "window" then
	-- 				state = resurrect.load_state(id, "window")
	-- 				resurrect.window_state.restore_window(win:mux_window(), state, {
	-- 					relative = true,
	-- 					restore_text = true,
	-- 					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	-- 					-- tab = win:active_tab(), -- uncomment this line to replace active tab
	-- 				})
	-- 			end
	-- 		end)
	-- 	end),
	-- },
	{
		key = "r",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
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
