vim.cmd("let g:floaterm_opener='vsplit'")
vim.cmd("let g:floaterm_width=0.8")
vim.cmd("let g:floaterm_height=0.8")

vim.api.nvim_set_keymap('n', '<leader>vct', ':FloatermNew lazygit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fex', ':FloatermNew ranger<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>trm', ':FloatermNew fish<CR>', { noremap = true, silent = true })
