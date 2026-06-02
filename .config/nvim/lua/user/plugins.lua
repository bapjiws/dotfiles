local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Misc
  { "tpope/vim-unimpaired" },
  { "mg979/vim-visual-multi" },
  { "thinca/vim-qfreplace" },
  { "windwp/nvim-autopairs" },
  { "numToStr/Comment.nvim" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  -- Surround (replaces tpope/vim-surround)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- UI
  { "nvim-lualine/lualine.nvim" },
  { "akinsho/bufferline.nvim", version = "*" },
  { "moll/vim-bbye" },
  { "navarasu/onedark.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- Colour highlighting (replaces chrisbra/Colorizer)
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          css = true,
          tailwind = true,
        },
      })
    end,
  },

  -- Keybinding discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>s", group = "Search" },
        { "<leader>f", group = "Find" },
        { "<leader>v", group = "VCS / Git" },
        { "<leader>d", group = "Diagnostics / Definitions" },
        { "<leader>t", group = "Terminal / Toggle" },
        { "<leader>c", group = "Commands / Code" },
        { "<leader>r", group = "References / Rename" },
      })
    end,
  },

  -- Snacks (UI utilities — replaces alpha, floaterm, dressing, neoscroll, indent-blankline)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
                               __
  ___     ___    ___   __  __ /\_\    ___ ___
 / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\
/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \
\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
 \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
          keys = {
            { icon = " ", key = "f", desc = "Find File",     action = function() Snacks.picker.files({ hidden = true }) end },
            { icon = " ", key = "e", desc = "New File",      action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files",  action = function() Snacks.picker.recent() end },
            { icon = " ", key = "t", desc = "Find Text",     action = function() Snacks.picker.grep() end },
            { icon = " ", key = "c", desc = "Configuration", action = ":e ~/.config/nvim/init.lua" },
            { icon = " ", key = "q", desc = "Quit",          action = ":qa" },
          },
        },
      },
      input   = {
        enabled = true,
        win = { relative = "editor", width = 100, height = 10 },
      },
      indent  = { enabled = true },
      scroll  = { enabled = true },
      terminal = { enabled = true },
      lazygit  = { enabled = true },
      picker   = { enabled = true },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Terminal keymaps (replaces vim-floaterm)
      vim.keymap.set("n", "<leader>vct", function() Snacks.lazygit() end,           { desc = "Lazygit" })
      vim.keymap.set("n", "<leader>fex", function() Snacks.terminal("ranger") end,  { desc = "File explorer (ranger)" })
      vim.keymap.set("n", "<leader>trm", function() Snacks.terminal("fish") end,    { desc = "Terminal" })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/cmp-nvim-lsp" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  -- LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettierd",
          "stylua",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },
  { "neovim/nvim-lspconfig" },
  { "RRethy/vim-illuminate" },
  { "j-hui/fidget.nvim" },

  -- Formatting (replaces none-ls)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua        = { "stylua" },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact  = { "prettierd" },
          typescriptreact  = { "prettierd" },
          css      = { "prettierd" },
          html     = { "prettierd" },
          json     = { "prettierd" },
          yaml     = { "prettierd" },
          markdown = { "prettierd" },
        },
        formatters = {
          prettierd = { prefer_local = "node_modules/.bin" },
        },
      })
    end,
  },

  -- Linting (replaces none-ls eslint source)
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      -- eslint diagnostics come from the eslint LSP server; nvim-lint
      -- handles any ft that doesn't have a dedicated LSP linter
      lint.linters_by_ft = {}
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
  },

  -- Git
  { "lewis6991/gitsigns.nvim" },

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    config = function()
      require("render-markdown").setup()
    end,
  },

  -- AI agent
  {
    "NickvanDyke/opencode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = "snacks",
          ---@type opencode.provider.Snacks
          snacks = {},
        },
        ask = {
          snacks = {
            win = { relative = "editor", width = 100, height = 50 },
          },
        },
      }

      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<leader>cmd", function() require("opencode").select() end,                         { desc = "All commands" })
      vim.keymap.set({ "n", "x" }, "<leader>ask", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask" })
      vim.keymap.set({ "n", "x" }, "<leader>ths", function() require("opencode").prompt("@this") end,                  { desc = "Add to opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>slt", function() require("opencode").prompt("@selection") end,             { desc = "Add selection" })
      vim.keymap.set({ "n", "t" }, "<leader>tgl", function() require("opencode").toggle() end,                         { desc = "Toggle opencode" })
      vim.keymap.set("n", "<leader>ssn", function() require("opencode").command("session.new") end,                    { desc = "New session" })
      vim.keymap.set("n", "<leader>ssl", function() require("opencode").command("session.list") end,                   { desc = "List sessions" })
      vim.keymap.set("n", "<S-C-k>", function() require("opencode").command("session.half.page.up") end,               { desc = "opencode page up" })
      vim.keymap.set("n", "<S-C-j>", function() require("opencode").command("session.half.page.down") end,             { desc = "opencode page down" })

      vim.keymap.set("n", "<leader>ttc", function()
        vim.cmd("vsplit")
        vim.cmd('terminal fish -lc "tt claude"')
        vim.cmd("startinsert")
      end, { desc = "Open tt claude" })
    end,
  },

}, {
  ui = { border = "rounded" },
})
