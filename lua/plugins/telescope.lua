return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep (search text in files)" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Find open buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Search help tags" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>",    desc = "Search Keymaps" },
	},
	config = function()
		require("telescope").setup({})
	end,
}
