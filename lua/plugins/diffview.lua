return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Open diff view" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>",   desc = "File history (whole repo)" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>",         desc = "Close diff view" },
	},
	opts = {},
}
