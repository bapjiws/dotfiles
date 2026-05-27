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
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-surround" },
  { "tpope/vim-unimpaired" },
  { "mg979/vim-visual-multi" },
  { "thinca/vim-qfreplace" },
  { "windwp/nvim-autopairs" },
  { "numToStr/Comment.nvim" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  -- UI
  { "nvim-lualine/lualine.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "karb94/neoscroll.nvim" },
  { "chrisbra/Colorizer" },
  { "navarasu/onedark.nvim" },
  { "akinsho/bufferline.nvim", version = "*" },
  { "moll/vim-bbye" },
  { "goolord/alpha-nvim" },
  { "voldikss/vim-floaterm" },
  { "stevearc/dressing.nvim" },

  -- Icons (shared dependency)
  { "nvim-tree/nvim-web-devicons" },

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
  { "neovim/nvim-lspconfig" },
  { "RRethy/vim-illuminate" },
  { "tamago324/nlsp-settings.nvim" },
  { "j-hui/fidget.nvim" },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvimtools/none-ls-extras.nvim" },
  },

  -- Telescope
  { "nvim-telescope/telescope.nvim" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
  },

  -- Git
  { "lewis6991/gitsigns.nvim" },

  -- Markdown
  { "MeanderingProgrammer/render-markdown.nvim" },
  { "HakonHarnes/img-clip.nvim" },
  { "MunifTanjim/nui.nvim" },

  -- Snacks (UI utilities, required by opencode.nvim)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
  },

  -- AI agent
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = {
        input = {
          win = {
            relative = "editor",
            width = 100,
            height = 10,
          }
        },
        picker = {},
        terminal = {}
      }},
    },
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
            win = {
              relative = "editor",
              width = 100,
              height = 50,
            }
          }
        }
      }

      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<leader>cmd", function() require("opencode").select() end, { desc = "All commands" })
      vim.keymap.set({ "n", "x" }, "<leader>ask", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask" })
      vim.keymap.set({ "n", "x" }, "<leader>ths", function() require("opencode").prompt("@this") end, { desc = "Add to opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>slt", function() require("opencode").prompt("@selection") end, { desc = "Add selection" })
      vim.keymap.set({ "n", "t" }, "<leader>tgl", function() require("opencode").toggle() end, { desc = "Toggle" })
      vim.keymap.set("n", "<leader>ssn", function() require("opencode").command("session.new") end, { desc = "New session" })
      vim.keymap.set("n", "<leader>ssl", function() require("opencode").command("session.list") end, { desc = "List all sessions" })
      vim.keymap.set("n", "<S-C-k>", function() require("opencode").command("session.half.page.up") end, { desc = "opencode half page up" })
      vim.keymap.set("n", "<S-C-j>", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })

      vim.keymap.set('n', '<leader>ttc', function()
        vim.cmd('vsplit')
        vim.cmd('terminal fish -lc "tt claude"')
        vim.cmd('startinsert')
      end, { desc = 'Open tt claude' })
    end,
  },

}, {
  ui = {
    border = "rounded",
  },
})
