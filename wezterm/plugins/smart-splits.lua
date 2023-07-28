local w = require("wezterm")

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(is_resize_key, key)
	return {
		key = key,
		mods = is_resize_key and "META" or "CTRL",
		action = w.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = is_resize_key and "META" or "CTRL" },
				}, pane)
			else
				if is_resize_key then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

return {
	keys = {
		-- move between split panes
		split_nav(false, "h"),
		split_nav(false, "j"),
		split_nav(false, "k"),
		split_nav(false, "l"),
		-- resize panes
		split_nav(true, "h"),
		split_nav(true, "j"),
		split_nav(true, "k"),
		split_nav(true, "l"),
	},
}
