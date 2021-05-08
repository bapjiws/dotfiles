:lua << EOF
--https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json", "graphql", "bash", "regex", "yaml", "lua" },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "]v", --"grn",
      node_decremental = "[v", --"grm",
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
}

EOF
