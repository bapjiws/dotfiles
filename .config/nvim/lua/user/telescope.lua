local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

local actions = require 'telescope.actions'

telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    file_ignore_patterns = { "node_modules" },

    mappings = {
      i = {
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true
    }
  },
}

local opts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', '<leader>sif', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fwf', [[<cmd>lua require('telescope.builtin').find_files({ default_text = vim.fn.expand("<cword>") })<CR>]], opts)

vim.api.nvim_set_keymap('n', '<leader>sip', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fwp', [[<cmd>lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") })<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fqp', [[<cmd>lua local line = vim.fn.getline(".") local start = string.find(line, '"[^"]*"') if start then local end_pos = string.find(line, '"', start + 1) if end_pos then local text = string.sub(line, start + 1, end_pos - 1) require('telescope.builtin').live_grep({ default_text = text }) else require('telescope.builtin').live_grep() end else require('telescope.builtin').live_grep() end<CR>]], opts)

vim.api.nvim_set_keymap('n', '<Leader>sib', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], opts)

vim.api.nvim_set_keymap('n', '<Leader>cmd', [[<Cmd>lua require('telescope.builtin').commands()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>cmh', [[<Cmd>lua require('telescope.builtin').command_history()<CR>]], opts)

vim.api.nvim_set_keymap('n', '<Leader>sih', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>fwh', [[<Cmd>lua require('telescope.builtin').help_tags({ default_text = vim.fn.expand("<cword>") })<CR>]], opts)

vim.api.nvim_set_keymap('n', '<Leader>rfc', [[<Cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)

vim.api.nvim_set_keymap('n', '<Leader>vst', [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opts)
