if vim.fn.has("nvim-0.11") == 0 then
  vim.api.nvim_echo({
    { "This config needs Neovim >= 0.11 (you have " .. tostring(vim.version()) .. ").\n", "ErrorMsg" },
    { "Update Neovim, then restart.\n", "WarningMsg" },
  }, true, {})
  return
end

require("config.options") -- also sets the leader key and loads config/local.lua, so it must come first
require("config.lazy")
require("config.autocmds")
require("config.keymaps")
require("config.colorscheme-cycle")
