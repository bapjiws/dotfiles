require "bufferline".setup {
    options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        max_name_length = 25,
        tab_size = 30,
        separator_style = "thin",
    },
}

-- [b and ]b are already set by unimpaired.
vim.api.nvim_set_keymap('n', ']x', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[x', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<S-x>', ':Bwipeout<CR>', { noremap = true, silent = true })
