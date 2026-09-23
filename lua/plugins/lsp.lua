return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"Hoffs/omnisharp-extended-lsp.nvim", -- add this
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"rust_analyzer",
				"html",
				"cssls",
				"jdtls",
				"lua_ls",
				"omnisharp", -- add this
			},
		})

		vim.lsp.config("omnisharp", {
			handlers = {
				["textDocument/definition"] = require("omnisharp_extended").handler,
			},
			enable_roslyn_analyzers = true,
			organize_imports_on_format = true,
			enable_import_completion = true,
		})

		vim.lsp.enable({
			"clangd",
			"rust_analyzer",
			"html",
			"cssls",
			"jdtls",
			"lua_ls",
			"omnisharp", -- add this
		})

		-- (rest unchanged)
	end,
}
