local opts = {noremap = true, silent = true}
local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Clean up the search results
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

keymap("n", "<C-h>", ":vertical resize +5<CR>", opts)
keymap("n", "<C-j>", ":resize -5<CR>", opts)
keymap("n", "<C-k>", ":resize +5<CR>", opts)
keymap("n", "<C-l>", ":vertical resize -5<CR>", opts)

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-f>", "<C-f>zz", opts)
keymap("n", "<C-b>", "<C-b>zz", opts)

keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "n", "nzz", opts)

keymap("n", "<leader>wrt", ":w<CR>", opts)

keymap("x", "<leader>pst", "\"_dP", opts)
