local env = require("config.env")

-- lspconfig server names
local servers = { "clangd", "rust_analyzer", "lua_ls", "html", "cssls", "jdtls" }
local unity = env.optional("unity")
if unity then table.insert(servers, "omnisharp") end

-- skip servers whose runtime/installer isn't present, so nothing errors
local needs = { html = "npm", cssls = "npm", jdtls = "java" }
local wanted = vim.tbl_filter(function(name)
  return not needs[name] or env.has(needs[name])
end, servers)

local deps = { "saghen/blink.cmp" }
if env.use_mason then
  vim.list_extend(deps, { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" })
end
if unity then table.insert(deps, "Hoffs/omnisharp-extended-lsp.nvim") end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = deps,
  config = function()
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
      vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
    end

    if unity then
      local omni = require("omnisharp_extended")
      vim.lsp.config("omnisharp", {
        handlers = {
          ["textDocument/definition"] = omni.definition_handler,
          ["textDocument/typeDefinition"] = omni.type_definition_handler,
          ["textDocument/references"] = omni.references_handler,
          ["textDocument/implementation"] = omni.implementation_handler,
        },
        settings = {
          RoslynExtensionsOptions = { EnableAnalyzersSupport = true, EnableImportCompletion = true },
          FormattingOptions = { OrganizeImports = true },
        },
      })
    end

    if env.use_mason then
      -- Linux / macOS / Windows: Mason downloads the servers
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = wanted,
        automatic_enable = wanted,
      })
    else
      -- Termux or minimal systems: use servers from the system package manager,
      -- and quietly skip any that aren't installed
      for _, name in ipairs(wanted) do
        local cmd = vim.lsp.config[name] and vim.lsp.config[name].cmd
        local usable = (type(cmd) == "table" and env.has(cmd[1])) or (type(cmd) == "function" and env.has(name))
        if usable then vim.lsp.enable(name) end
      end
    end

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
        -- K (hover), grr (references), grn, gra are built into nvim 0.11+
      end,
    })
  end,
}
