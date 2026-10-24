local env = require("config.env")

-- main-branch nvim-treesitter compiles parsers, so it needs the tree-sitter CLI and a C compiler
local can_compile = env.has("tree-sitter") and (env.has("cc") or env.has("gcc") or env.has("clang"))

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- this branch does not support lazy-loading
  build = can_compile and ":TSUpdate" or nil,
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({})

    if can_compile then
      ts.install({ "c", "rust", "asm", "html", "css", "java", "c_sharp", "lua", "vim", "vimdoc" })
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
