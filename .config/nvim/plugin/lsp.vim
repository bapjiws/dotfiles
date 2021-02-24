:lua << EOF
--https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}

--https://github.com/iamcco/diagnostic-languageserver/wiki/Linters#eslint
require'lspconfig'.diagnosticls.setup{
  on_attach=require'completion'.on_attach,
  filetypes = { "javascript", "javascript.jsx" },
  init_options = {
    filetypes = {
      javascript = "eslint",
      ["javascript.jsx"] = "eslint",
      javascriptreact = "eslint",
      typescriptreact = "eslint",
    },
    linters = {
      eslint = {
        sourceName = "eslint",
        command = "./node_modules/.bin/eslint",
        rootPatterns = { ".git" },
        debounce = 100,
        args = {
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json",
        },
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "[eslint] ${message} [${ruleId}]",
          security = "severity",
        };
        securities = {
          [2] = "error",
          [1] = "warning"
        }
      }
    },
    formatters = {
      --https://github.com/prettier/prettier-eslint-cli
      prettierEslint = {
        command = './node_modules/.bin/prettier-eslint',
        args = { '--stdin' },
        rootPatterns = { '.git' },
      },
      prettier = {
        command = './node_modules/.bin/prettier',
        args = { '--stdin-filepath', '%filename' },
        rootPatterns = { '.git' },
      }
    },
    formatFiletypes = {
       css = 'prettier',
       javascript = 'prettierEslint',
       javascriptreact = 'prettierEslint',
       json = 'prettier',
       scss = 'prettier',
       typescript = 'prettierEslint',
       typescriptreact = 'prettierEslint'
    }
  }
}

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
