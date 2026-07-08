return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "c", "rust", "asm", "html", "css", "java",
        "lua", -- for editing your own nvim config
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
