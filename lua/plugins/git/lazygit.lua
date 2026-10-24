return {
	"kdheepak/lazygit.nvim",
	enabled = vim.fn.executable("lazygit") == 1, -- hidden when the binary is missing
	cmd = "LazyGit",
	keys = {
		{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
	},
	dependencies = { "nvim-lua/plenary.nvim" },
}
