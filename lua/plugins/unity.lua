return {
  {
    "insprill/unity-nvim-adapter",
    lazy = false,
  },
  {
    "apyra/nvim-unity-sync",
    ft = "cs",
    config = function()
      require("unity.plugin").setup({
        unity_cs_template = true,
      })
    end,
  },
}
