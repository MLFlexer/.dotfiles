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
		key = "b",
		mods = "ALT",
		action = wezterm.action.Multiple({
			wezterm.action_callback(function(win, pane)
				-- wezterm.mux.write_session_state("/tmp/wezterm/session_state.json")
				local workspace_switcher = wezterm.plugin.require_as_alias(
					"https://github.com/MLFlexer/smart_workspace_switcher.wezterm/",
					"some_alias"
				)

				wezterm.log_info(workspace_switcher.a)
				-- local ws = require("some_alias.plugin.init")
				-- wezterm.log_info(ws)
				wezterm.log_info(require("some_alias"))
			end),
		}),
	},
	{
		key = "v",
		mods = "ALT",
		action = wezterm.action.Multiple({
			wezterm.action_callback(function(win, pane)
				wezterm.reload_configuration()
			end),
		}),
	},
	{
		key = "m",
		mods = "ALT",
		action = wezterm.action.Multiple({
			wezterm.action_callback(function(win, pane)
				local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
				resurrect.fuzzy_load(win, pane, function(id, label)
					id = string.match(id, "([^/]+)$")
					id = string.match(id, "(.+)%..+$")
					local state = resurrect.load_state(id, "workspace")
					local workspace_state = resurrect.workspace_state
					workspace_state.restore_workspace(state, {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					})
				end)
			end),
		}),
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
