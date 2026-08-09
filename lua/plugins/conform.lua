return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- load right before you save a file
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function() require("conform").format({ async = true }) end,
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			c = { "clang-format" },
			rust = { "rustfmt" },
			lua = { "stylua" },
			html = { "prettier" },
			css = { "prettier" },
			java = { "google-java-format" },
		},
		formatters = {
			["clang-format"] = {
				prepend_args = { "-style={IndentWidth: 4, UseTab: Never}" },
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback", -- use LSP formatting if no dedicated formatter is configured
		},
	},
}
