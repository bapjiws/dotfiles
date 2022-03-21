local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
  return
end

gitsigns.setup {
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 500,
  },
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    -- map('n', '<leader>stg', ':Gitsigns stage_hunk<CR>')
    -- map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')

    map('n', '<leader>und', ':Gitsigns reset_hunk<CR>')
    map('v', '<leader>und', ':Gitsigns reset_hunk<CR>')

    -- map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
    -- map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
    map('n', '<leader>rst', '<cmd>Gitsigns reset_buffer<CR>')
    map('n', '<leader>prw', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', '<leader>bll', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    map('n', '<leader>dff', '<cmd>Gitsigns diffthis<CR>')
    -- map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
    map('n', '<leader>tgd', '<cmd>Gitsigns toggle_deleted<CR>')

    -- Text object
    -- map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    -- map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
