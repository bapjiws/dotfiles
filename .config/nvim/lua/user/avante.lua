require('avante').setup({
  provider = "copilot"
})

vim.api.nvim_set_keymap('n', '<leader>cc', ":AvanteChat<CR>", { noremap = true, silent = true })
