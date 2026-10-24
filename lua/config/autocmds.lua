local group = vim.api.nvim_create_augroup("user-autocmds", { clear = true })

-- Custom line-number colours, re-applied after every colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#FF8C00" })
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#2E8B57" })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#2AA198" })
  end,
})

-- jupytext.nvim errors on empty/invalid .ipynb files (it json.decodes the raw
-- content), so write a minimal valid notebook before its BufReadCmd runs.
vim.api.nvim_create_autocmd("BufReadPre", {
  group = group,
  pattern = "*.ipynb",
  callback = function(args)
    local f = io.open(args.match, "r")
    if not f then return end
    local content = f:read("*a")
    f:close()

    if content ~= "" and pcall(vim.json.decode, content) then return end

    local out = io.open(args.match, "w")
    if out then
      out:write('{\n "cells": [],\n "metadata": {},\n "nbformat": 4,\n "nbformat_minor": 5\n}\n')
      out:close()
    end
  end,
})
