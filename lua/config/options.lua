vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250

-- No perl/ruby plugins here, so skip those providers (keeps :checkhealth quiet)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Python for molten/jupyter: NVIM_PYTHON env var, or set it in config/local.lua
if vim.env.NVIM_PYTHON and vim.env.NVIM_PYTHON ~= "" then
  vim.g.python3_host_prog = vim.env.NVIM_PYTHON
end

-- Personal overrides (gitignored, optional)
pcall(require, "config.local")
