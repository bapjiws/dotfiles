require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "bash",
        "json",
        "yaml",
        "regex",
        "lua",
        "graphql"
    },
    highlight = {
        enable = true,
        use_languagetree = true
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
    }
}
