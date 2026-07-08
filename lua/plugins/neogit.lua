return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",    -- neogit uses diffview for its diff views
		"nvim-telescope/telescope.nvim", -- optional, for branch/commit pickers
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>gs", "<cmd>Neogit<cr>", desc = "Open Neogit status" },
	},
	opts = {},
}
