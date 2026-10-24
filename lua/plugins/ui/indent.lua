return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = { char = "│" },
			scope = { enabled = true, show_start = true, show_end = true },
			exclude = {
				filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
			},
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		submodules = false, -- its submodules are test-only and live on gitlab.com
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("rainbow-delimiters.setup").setup({
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			})
		end,
	},
}
