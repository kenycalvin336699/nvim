return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- this branch does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})

    require("nvim-treesitter").install({
      "c", "rust", "asm", "html", "css", "java", "c_sharp", "lua", "vim", "vimdoc",
    })

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
