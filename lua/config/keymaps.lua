-- General keymaps that aren't tied to one plugin's lifecycle.
-- Plugin-specific keymaps (LSP, gitsigns, a plugin's own launcher key)
-- stay inside that plugin's own file in lua/plugins/ — see the note below.

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Open diagnostics for the whole workspace in the quickfix list
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

-- Move focus between windows — handy for hopping in/out of nvim-tree or neo-tree
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
