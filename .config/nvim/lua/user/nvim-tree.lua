-- require'nvim-tree'.setup {}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

-- https://github.com/kyazdani42/nvim-tree.lua#keybindings
nvim_tree.setup {
  diagnostics = {
    enable = true,
  },
  update_cwd = true,
  update_to_buf_dir = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
}

local opts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', '<leader>fex', ':NvimTreeFindFile<CR>', opts)
