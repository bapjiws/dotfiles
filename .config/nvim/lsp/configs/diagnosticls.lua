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
