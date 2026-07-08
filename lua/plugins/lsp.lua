return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd", -- C
				"rust_analyzer", -- Rust
				"html",
				"cssls",
				"jdtls", -- Java
				"lua_ls", -- Lua (for editing your nvim config)
			},
		})

		vim.lsp.enable({
			"clangd",
			"rust_analyzer",
			"html",
			"cssls",
			"jdtls",
			"lua_ls",
		})

		-- keymaps that only apply in buffers where an LSP is attached
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
				end
				map("gd", vim.lsp.buf.definition, "Go to definition")
				map("gr", vim.lsp.buf.references, "Go to references")
				map("K", vim.lsp.buf.hover, "Hover documentation")
				map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
				map("<leader>ca", vim.lsp.buf.code_action, "Code action")
			end,
		})
	end,
}
