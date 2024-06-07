local wezterm = require("wezterm")
local font = wezterm.font
local harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }
return {
	-- default font
	font = wezterm.font_with_fallback({
		{
			family = "Monaspace Neon",
			-- family = "Monaspace Argon",
			-- family = "Monaspace Xenon",
			-- family = "Monaspace Radon",
			-- family = "Monaspace Krypton",
			weight = "Medium",
			harfbuzz_features = harfbuzz_features,
		},
		"Font Awesome",
		"Noto Color Emoji",
	}),

	font_rules = {
		{ -- Normal
			intensity = "Normal",
			italic = false,
			font = font({
				family = "Monaspace Neon",
				weight = "Medium",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Bold
			intensity = "Bold",
			italic = false,
			font = font({
				family = "Monaspace Argon",
				weight = "ExtraBold",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Half
			intensity = "Half",
			italic = false,
			font = font({
				family = "Monaspace Krypton",
				weight = "Book",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Normal italic
			intensity = "Normal",
			italic = true,
			font = font({
				family = "Monaspace Argon",
				weight = "Regular",
				style = "Italic",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Bold italic
			intensity = "Bold",
			italic = true,
			font = font({
				family = "Monaspace Argon",
				weight = "DemiBold",
				style = "Italic",
				harfbuzz_features = harfbuzz_features,
			}),
		},
		{ -- Half italic
			intensity = "Half",
			italic = true,
			font = font({
				family = "Monaspace Argon",
				weight = "Thin",
				style = "Italic",
				harfbuzz_features = harfbuzz_features,
			}),
		},
	},
}
