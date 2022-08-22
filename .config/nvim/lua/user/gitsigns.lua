local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
  return
end

gitsigns.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 500,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>sth', '<cmd>Gitsigns stage_hunk<CR>')
    map('n', '<leader>stb', '<cmd>Gitsigns stage_buffer<CR>')
    map('n', '<leader>ush', '<cmd>Gitsigns undo_stage_hunk<CR>')
    map('n', '<leader>rsh', '<cmd>Gitsigns reset_hunk<CR>')
    map('n', '<leader>rsb', '<cmd>Gitsigns reset_buffer<CR>')

    map('n', '<leader>slh', '<cmd>Gitsigns select_hunk<CR>')
    map('n', '<leader>prw', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', '<leader>bll', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    map('n', '<leader>dff', '<cmd>Gitsigns diffthis<CR>')
    map('n', '<leader>tgd', '<cmd>Gitsigns toggle_deleted<CR>')
  end
}
