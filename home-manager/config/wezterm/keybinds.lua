local wezterm = require("wezterm")
local act = wezterm.action

wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

wezterm.on("update_plugins", function(_, _)
	wezterm.plugin.update_all()
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "workspace_switch" then
		local workspace_name = string.match(value, ".+/(.+)$")
		window:perform_action(
			act.SwitchToWorkspace({
				name = workspace_name,
				spawn = { cwd = value },
			}),
			pane
		)
		window:set_right_status(window:active_workspace())
	elseif name == "workspace_switch_session_name" then
		window:perform_action(
			act.SwitchToWorkspace({
				name = value,
			}),
			pane
		)
		window:set_right_status(window:active_workspace())
	end
end)

wezterm.on("spawn_lazygit", function(window, pane)
	local current_tab_id = pane:tab():tab_id()
	local cmd = "lazygit ; wezterm cli activate-tab --tab-id " .. current_tab_id .. " ; exit\n"
	local tab, tab_pane, _ = window:mux_window():spawn_tab({})
	tab_pane:send_text(cmd)
	tab:set_title(wezterm.nerdfonts.dev_git .. " Lazygit")
end)

wezterm.on("go_to_dotfiles", function(window, pane)
	window:perform_action(
		act.SwitchToWorkspace({
			name = ".dotfiles",
			spawn = { cwd = wezterm.home_dir .. "/repos/.dotfiles" },
		}),
		pane
	)
	window:set_right_status(window:active_workspace())
end)

local function tab_switch_keys(keys, modifier)
	for i = 1, 9 do
		table.insert(keys, {
			key = tostring(i),
			mods = modifier,
			action = act.ActivateTab(i - 1),
		})
	end
	table.insert(keys, {
		key = "0",
		mods = modifier,
		action = act.ActivateTab(9),
	})
end

local keys = {
	{
		key = "g",
		mods = "ALT",
		action = act.EmitEvent("spawn_lazygit"),
	},
	{
		key = "-",
		mods = "ALT",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "_",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = "m",
		mods = "ALT",
		action = wezterm.action.TogglePaneZoomState,
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
		key = "s",
		mods = "LEADER",
		action = act.EmitEvent("smart_workspace_switcher"),
	},
	{
		key = "d",
		mods = "LEADER",
		action = act.EmitEvent("go_to_dotfiles"),
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
		key = "U",
		mods = "LEADER|SHIFT",
		action = act.EmitEvent("update_plugins"),
	},
}

tab_switch_keys(keys, "ALT")

return keys
