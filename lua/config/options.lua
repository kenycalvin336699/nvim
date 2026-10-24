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

-- Only use this Python if it exists (needed by molten/jupyter)
local py = "/mount/storage/llm-fcc/cuda/bin/python"
if (vim.uv or vim.loop).fs_stat(py) then
  vim.g.python3_host_prog = py
end
