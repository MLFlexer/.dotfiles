-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	return
end

    -- get lualine onedark theme
local lualine_onedark = require("lualine.themes.onedark")

-- configure lualine with modified theme
lualine.setup({
	options = {
		theme = lualine_onedark,
	},
})
