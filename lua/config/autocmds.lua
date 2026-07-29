-- Fix jupytext.nvim erroring on empty or invalid .ipynb files
-- (it json.decodes the raw content). Populate a minimal valid
-- notebook before jupytext's BufReadCmd runs.
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#FF8C00" })
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#2E8B57" })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#2AA198" })
	end,
})
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = "*.ipynb",
	callback = function(args)
		local path = args.match
		local f = io.open(path, "r")
		if not f then
			return
		end
		local content = f:read("*a")
		f:close()

		local ok = content ~= "" and pcall(vim.json.decode, content)

		if not ok then
			local template = [[{
 "cells": [],
 "metadata": {},
 "nbformat": 4,
 "nbformat_minor": 5
}
]]
			local out = io.open(path, "w")
			if out then
				out:write(template)
				out:close()
			end
		end
	end,
})
