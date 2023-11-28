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
  refactor = {
    highlight_definitions = { enable = true },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "<leader>dfn",
        goto_next_usage = "]w",
        goto_previous_usage = "[w",
      },
    },
  },
  autopairs = {
		enable = true,
	},
}
