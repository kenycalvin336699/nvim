local uv = vim.uv or vim.loop
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins.core" },
    { import = "plugins.git" },
    { import = "plugins.ui" },
    { import = "plugins.files" },
    { import = "plugins.dev" },
  },
  concurrency = 2,                  -- fewer parallel clones = fewer dropped connections
  git = { timeout = 600 },          -- default 120s is what killed gitsigns/lspconfig
  checker = { enabled = false },
  change_detection = { notify = false },
})
