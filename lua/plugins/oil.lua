return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, adds file icons
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true, -- show dotfiles like .gitignore, .bashrc
      },
    })
  end,
}

