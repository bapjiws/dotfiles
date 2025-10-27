require('avante').setup({
  provider = "copilot"
})

vim.api.nvim_set_keymap('n', '<leader>ccc', ":AvanteChat<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ccn', ":AvanteChatNew<CR>", { noremap = true, silent = true })
