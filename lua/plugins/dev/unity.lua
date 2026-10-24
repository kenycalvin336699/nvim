local env = require("config.env")

-- Opt-in: enable with `vim.g.enable_unity = true` in lua/config/local.lua (or NVIM_UNITY=1).
-- unity-nvim-adapter also needs a Rust toolchain to build its binary.
if not env.optional("unity") or env.is_termux then
  return {}
end

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
