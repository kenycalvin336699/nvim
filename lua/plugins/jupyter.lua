return {
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty", -- or "ueberzug" if not on a kitty-compatible terminal
			max_width = 100,
			max_height = 12,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		},
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- pin to stable
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_auto_open_output = false
			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = true
		end,
		keys = {
			{ "<leader>mi", "<cmd>MoltenInit<cr>",              desc = "Molten: init kernel" },
			{ "<leader>me", "<cmd>MoltenEvaluateOperator<cr>",  desc = "Molten: evaluate operator" },
			{ "<leader>ms", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v",                        desc = "Molten: evaluate visual" },
			{ "<leader>mr", "<cmd>MoltenReevaluateCell<cr>",    desc = "Molten: re-evaluate cell" },
			{ "<leader>mo", "<cmd>MoltenShowOutput<cr>",        desc = "Molten: show output" },
			{ "<leader>mh", "<cmd>MoltenHideOutput<cr>",        desc = "Molten: hide output" },
			{ "<leader>md", "<cmd>MoltenDelete<cr>",            desc = "Molten: delete cell" },
		},
	},
	{
		"GCBallesteros/jupytext.nvim",
		config = true,
		-- opts = { style = "markdown", output_extension = "md", force_ft = "markdown" },
	},
}
