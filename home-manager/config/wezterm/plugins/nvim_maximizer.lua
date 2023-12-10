local wezterm = require("wezterm")

local function is_vim(pane)
	return pane:get_foreground_process_info().name == "nvim"
end

local function is_zoomed(tab)
	for _, item in ipairs(tab:panes_with_info()) do
		if item.is_zoomed then
			return true
		end
	end
	return false
end

local function fully_maximize(key, mods)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to nvim
				if is_zoomed(win:active_tab()) then
					win:perform_action(wezterm.action.TogglePaneZoomState, pane)
					win:perform_action(
						wezterm.action.Multiple({
							wezterm.action.SendKey({ key = "Space" }),
							wezterm.action.SendKey({ key = "m" }),
						}),
						pane
					)
				else
					win:perform_action(
						wezterm.action.Multiple({
							wezterm.action.SendKey({ key = "Space" }),
							wezterm.action.SendKey({ key = "M" }),
							wezterm.action.TogglePaneZoomState,
							wezterm.action.SendKey({ key = "Space" }),
							wezterm.action.SendKey({ key = "m" }),
						}),
						pane
					)
				end
			else
				win:perform_action(wezterm.action.TogglePaneZoomState, pane)
			end
		end),
	}
end

return {
	keys = {
		fully_maximize("M", "ALT"),
	},
}
