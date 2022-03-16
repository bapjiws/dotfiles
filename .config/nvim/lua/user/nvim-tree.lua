local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

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
   view = {
    width = 40,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
      },
    },
  },
}

local opts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', '<leader>fex', ':NvimTreeFindFile<CR>', opts)
