return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "Hoffs/omnisharp-extended-lsp.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "rust_analyzer", "html", "cssls", "jdtls", "lua_ls", "omnisharp" },
      automatic_enable = true, -- enables every installed server, no manual vim.lsp.enable needed
    })

    -- completion capabilities for every server
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    local omni = require("omnisharp_extended")
    vim.lsp.config("omnisharp", {
      handlers = {
        ["textDocument/definition"] = omni.definition_handler,
        ["textDocument/typeDefinition"] = omni.type_definition_handler,
        ["textDocument/references"] = omni.references_handler,
        ["textDocument/implementation"] = omni.implementation_handler,
      },
      settings = {
        RoslynExtensionsOptions = {
          EnableAnalyzersSupport = true,
          EnableImportCompletion = true,
        },
        FormattingOptions = { OrganizeImports = true },
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
      callback = function(ev)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        -- K (hover), grr (references), grn, gra are already built into nvim 0.11+
      end,
    })
  end,
}
