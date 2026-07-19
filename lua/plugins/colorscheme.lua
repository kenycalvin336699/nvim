return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				integrations = {
					treesitter = true,
					native_lsp = { enabled = true },
					neotree = true,
					nvimtree = true,
					which_key = true,
					gitsigns = true,
					telescope = true,
					mason = true,
				},
			})
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "storm", -- storm, moon, night, day
				transparent = false,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
				},
			})
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "wave", -- wave, dragon, lotus
				compile = false,
			})
		end,
	},

	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = false,
					styles = {
						comments = "italic",
						keywords = "bold",
					},
				},
			})
		end,
	},

}
