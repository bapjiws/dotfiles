require "user.options"
require "user.keymaps"
require "user.floaterm"
-- require "user.plugins"
--[[ require "user.autocommands" -- not complete ]]
-- require "user.cmp"
-- require "user.telescope"
-- require "user.autopairs"
-- require "user.gitsigns"
-- tequire "user.nvim-tree"
-- require "user.bufferline"
-- require "user.lualine"
-- require "user.bbye"
-- require "user.toggleterm"
-- require "user.project"
-- require "user.impatient"
-- require "user.indentline"
-- require "user.alpha"

-- WIP
-- require "user.treesitter"
-- require "user.lsp"

-- DONE
-- require "user.colorscheme"
-- require "user.comment"


-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
--  NOTE: also set in keymaps
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
      require('onedark').setup {
        style = 'deep'
      }
      require('onedark').load()
    end,
  },

  { 'voldikss/vim-floaterm' },

  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  { 'numToStr/Comment.nvim', opts = {
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
}, {})

-- [[ Configure Treesitter ]]
require('nvim-treesitter.configs').setup {
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
}

require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
}

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}
