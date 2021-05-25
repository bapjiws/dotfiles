require "bufferline".setup {
    options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        modified_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 25,
        max_prefix_length = 15,
        tab_size = 30,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        view = "multiwindow",
        separator_style = "thin",
        mappings = "true"
    },
}

-- [b and ]b are already set by unimpaired.
vim.api.nvim_set_keymap('n', ']x', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[x', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<S-x>', ':Bwipeout<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<TAB>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-TAB>', ':tabprevious<CR>', { noremap = true, silent = true })
