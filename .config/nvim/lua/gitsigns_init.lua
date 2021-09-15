require('gitsigns').setup {
  keymaps = {
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

    ['n <leader>und'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['n <leader>rst'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>prw'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>bll'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
    ['n <leader>shk'] = '<cmd>lua require"gitsigns".select_hunk()<CR>',

    -- TODO: try
    --['n <leader>bll'] = '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>',
  },
  -- TODO: test later, doesn't seem to work right now.
  current_line_blame = true,
}
