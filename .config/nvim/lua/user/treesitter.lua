local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "fish",
    "graphql",
    "html",
    "javascript",
    "json",
    "lua",
    "regex",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "]v",
      node_decremental = "[v",
    },
  },
  autopairs = {
		enable = true,
	},
}
