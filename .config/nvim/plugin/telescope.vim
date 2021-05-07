:lua << EOF
local actions = require('telescope.actions')	

require('telescope').setup {
    defaults = {
        mappings = {	
          i = {	
            ['<C-j>'] = actions.move_selection_next,	
            ['<C-k>'] = actions.move_selection_previous,	
            --['<C-x>'] = false,
            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
          },	
          n = {	
            --['<C-j>'] = actions.move_selection_next,	
            --['<C-k>'] = actions.move_selection_previous,	
            --['<esc>'] = actions.close,	
          },	
        },-- See https://github.com/BurntSushi/ripgrep/blob/master/complete/_rg for all options.
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_position = 'bottom',
        prompt_prefix = ' ',
        selection_caret = ' ',
        entry_prefix = '  ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        sorting_strategy = 'descending',
        layout_strategy = 'horizontal',
        layout_defaults = {
            horizontal = {
                mirror = false,
                preview_width = 0.5
            },
            vertical = {
                mirror = false
            }
        },
        file_sorter = require 'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
        shorten_path = true,
        winblend = 0,
        width = 0.75,
        preview_cutoff = 120,
        results_height = 1,
        results_width = 0.8,
        border = {},
        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        color_devicons = true,
        use_less = true,
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
        file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require 'telescope.previewers'.buffer_previewer_maker
    },
    --extensions = {
    --    media_files = {
    --        filetypes = {'png', 'webp', 'jpg', 'jpeg'},
    --        find_cmd = 'rg' -- find command (defaults to `fd`)
    --    }
    --}
}

--require('telescope').load_extension('media_files')

local opt = {noremap = true, silent = true}

vim.g.mapleader = ' '

-- TODO:
-- { default_text = vim.fn.expand("<cword>") }

-- mappings
vim.api.nvim_set_keymap('n', '<Leader>sif', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt)
vim.api.nvim_set_keymap('n', '<Leader>fwf', [[<Cmd>lua require('telescope.builtin').find_files({ default_text = vim.fn.expand("<cword>") })<CR>]], opt)

vim.api.nvim_set_keymap('n', '<Leader>sil', [[<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], opt)
vim.api.nvim_set_keymap('n', '<Leader>fwl', [[<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") })<CR>]], opt)


vim.api.nvim_set_keymap('n', '<Leader>sip', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opt)
vim.api.nvim_set_keymap('n', '<Leader>fwp', [[<Cmd>lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>]], opt)
-- TODO: not cword, but selected text.
vim.api.nvim_set_keymap('x', '<Leader>fwp', [[<Cmd>lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>]], opt)

vim.api.nvim_set_keymap('n', '<Leader>sib', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], opt)

-- TODO: sic?
vim.api.nvim_set_keymap('n', '<Leader>cmd', [[<Cmd>lua require('telescope.builtin').commands()<CR>]], opt)
vim.api.nvim_set_keymap('n', '<Leader>cmh', [[<Cmd>lua require('telescope.builtin').command_history()<CR>]], opt)


vim.api.nvim_set_keymap('n', '<Leader>sih', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], opt)
vim.api.nvim_set_keymap('n', '<Leader>fwh', [[<Cmd>lua require('telescope.builtin').help_tags({ default_text = vim.fn.expand("<cword>") })<CR>]], opt)


vim.api.nvim_set_keymap('n', '<Leader>rfc', [[<Cmd>lua require('telescope.builtin').lsp_references()<CR>]], opt)

-- TODO: do we need these 3?
vim.api.nvim_set_keymap('n', '<Leader>fcm', [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]], opt)
vim.api.nvim_set_keymap('n', '<Leader>pcm', [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], opt)
vim.api.nvim_set_keymap('n', '<Leader>chf', [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opt)

-- TODO: jump search

-- TODO: do we need these 3?
--vim.api.nvim_set_keymap('n', '<Leader>fp', [[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]], opt)
--vim.api.nvim_set_keymap('n', '<Leader>fo', [[<Cmd>lua require('telescope.builtin').oldfiles()<CR>]], opt)
--vim.api.nvim_set_keymap('n', '<Leader>fm', [[<Cmd> Neoformat<CR>]], opt)


-- highlights 
local cmd = vim.cmd

cmd 'hi TelescopeBorder   guifg=#2a2e36'
cmd 'hi TelescopePromptBorder   guifg=#2a2e36'
cmd 'hi TelescopeResultsBorder  guifg=#2a2e36'
cmd 'hi TelescopePreviewBorder  guifg=#525865'

-- TODO: from init.vim
-- highlight TelescopeSelection      guifg=#F27C04 gui=bold " selected item
-- highlight TelescopeSelectionCaret guifg=#CC241D " selection caret
-- highlight TelescopeMultiSelection guifg=#928374 " multisections
-- highlight TelescopeNormal         guibg=#00000  " floating windows created by telescope.
-- 
-- highlight TelescopeMatching       guifg=#16DBC2
EOF
