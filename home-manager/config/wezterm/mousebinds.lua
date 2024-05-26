local wezterm = require("wezterm")

return {
	{
		event = { Down = { streak = 4, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
	},
}
