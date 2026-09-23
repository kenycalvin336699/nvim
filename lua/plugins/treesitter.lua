return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "c", "rust", "asm", "html", "css", "java",
        "c_sharp", -- add this
        "lua",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
