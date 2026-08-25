local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
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
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
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
				{ "<leader>g", group = "GitHub" },
				{ "<leader>x", group = "Trouble (diagnostics)" },
				{ "<leader>dv", group = "Diffview" },
			})
		end,
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {
			auto_preview = false,
		},
		keys = {
			{
				"<leader>dgn",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer diagnostics (Trouble)",
			},
		},
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
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = function()
								Snacks.picker.files({ hidden = true })
							end,
						},
						{ icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = function()
								Snacks.picker.recent()
							end,
						},
						{
							icon = " ",
							key = "t",
							desc = "Find Text",
							action = function()
								Snacks.picker.grep()
							end,
						},
						{ icon = " ", key = "c", desc = "Configuration", action = ":e ~/.config/nvim/init.lua" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			input = {
				enabled = true,
				win = { relative = "editor", width = 100, height = 10 },
			},
			indent = { enabled = true },
			scroll = { enabled = true },
			terminal = { enabled = true },
			lazygit = { enabled = true },
			picker = { enabled = true },
			words = { enabled = true },
			gh = {},
			gitbrowse = {},
		},
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

	-- Local LLM FIM completion (talks to a llama-server instance you run yourself)
	{
		"ggml-org/llama.vim",
		init = function()
			vim.g.llama_config = {
				endpoint_fim = "http://127.0.0.1:8012/infill",
				auto_fim = true,
        show_info = 0, -- 0 = off, 1 = statusline, 2 = inline (default)
				-- <C-j>/<C-k> collide with cmp.lua's cmp-select-next/prev keymaps
				keymap_fim_next = "<M-]>",
				keymap_fim_prev = "<M-[>",
			}

			-- llama.vim has no buftype/filetype filtering of its own — it fires on every
			-- cursor move globally, which also hits picker/prompt inputs (e.g. Snacks
			-- pickers use buftype=prompt) and corrupts their statusline with FIM stats.
			-- Using FileType (not BufEnter+buftype check) because Snacks applies
			-- buftype/filetype to the picker's input buffer at a point that isn't
			-- reliably ordered relative to BufEnter — FileType only ever fires at the
			-- exact moment filetype is actually set, so there's no race to lose.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "snacks_picker_input",
				callback = function(args)
					vim.cmd("silent! LlamaDisable")
					-- strip any buffer-local FIM keymaps that were set on this buffer
					-- before this autocmd existed (llama.vim's <expr> cycle maps eat
					-- the keypress instead of falling back once disabled)
					for _, lhs in ipairs({ "<Tab>", "<S-Tab>", "<C-j>", "<C-k>", "<M-]>", "<M-[>" }) do
						pcall(vim.keymap.del, "i", lhs, { buffer = args.buf })
					end
					vim.api.nvim_create_autocmd("BufLeave", {
						buffer = args.buf,
						callback = function()
							vim.cmd("silent! LlamaEnable")
						end,
					})
				end,
			})
		end,
	},

	-- Snippets
	{ "L3MON4D3/LuaSnip" },

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
					"eslint_d",
					"stylua",
				},
				auto_update = false,
				run_on_start = true,
			})
		end,
	},
	{ "neovim/nvim-lspconfig" },
	{ "j-hui/fidget.nvim" },

	-- Formatting (replaces none-ls)
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Projects without a Prettier config format via `eslint --fix` instead,
					-- so prettierd's own config file (incl. package.json "prettier") gates it.
					javascript = { "prettierd", "eslint_d", stop_after_first = true },
					typescript = { "prettierd", "eslint_d", stop_after_first = true },
					javascriptreact = { "prettierd", "eslint_d", stop_after_first = true },
					typescriptreact = { "prettierd", "eslint_d", stop_after_first = true },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
				},
				formatters = {
					prettierd = {
						prefer_local = "node_modules/.bin",
						condition = function(self, ctx)
							return require("conform.formatters.prettierd").cwd(self, ctx) ~= nil
						end,
					},
					eslint_d = {
						prefer_local = "node_modules/.bin",
						condition = function(self, ctx)
							return vim.fs.find({
								"eslint.config.js",
								"eslint.config.mjs",
								"eslint.config.cjs",
								"eslint.config.ts",
								".eslintrc",
								".eslintrc.js",
								".eslintrc.cjs",
								".eslintrc.json",
								".eslintrc.yaml",
								".eslintrc.yml",
							}, { path = ctx.dirname, upward = true })[1] ~= nil
						end,
					},
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
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		},
	},

	-- Git
	{ "lewis6991/gitsigns.nvim" },
	{ "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },
	{ "luukvbaal/statuscol.nvim" },
	{ "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" } },

	-- Markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		config = function()
			require("render-markdown").setup()
		end,
	},

	-- Markdown + Mermaid live preview (opens in browser, no need to push to see rendering)
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{ "<leader>mdp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },
		},
	},

	-- AI agent
 --[[  { ]]
	--[[ 	"NickvanDyke/opencode.nvim", ]]
	--[[ 	dependencies = { "folke/snacks.nvim" }, ]]
	--[[ 	config = function() ]]
	--[[ 		---@type opencode.Opts ]]
	--[[ 		vim.g.opencode_opts = { ]]
	--[[ 			provider = { ]]
	--[[ 				enabled = "snacks", ]]
	--[[ 				---@type opencode.provider.Snacks ]]
	--[[ 				snacks = {}, ]]
	--[[ 			}, ]]
	--[[ 			ask = { ]]
	--[[ 				snacks = { ]]
	--[[ 					win = { relative = "editor", width = 100, height = 50 }, ]]
	--[[ 				}, ]]
	--[[ 			}, ]]
	--[[ 		} ]]
	--[[]]
	--[[ 		vim.o.autoread = true ]]
	--[[]]
	--[[ 		vim.keymap.set({ "n", "x" }, "<leader>cmd", function() ]]
	--[[ 			require("opencode").select() ]]
	--[[ 		end, { desc = "All commands" }) ]]
	--[[ 		vim.keymap.set({ "n", "x" }, "<leader>ask", function() ]]
	--[[ 			require("opencode").ask("@this: ", { submit = true }) ]]
	--[[ 		end, { desc = "Ask" }) ]]
	--[[ 		vim.keymap.set({ "n", "x" }, "<leader>ths", function() ]]
	--[[ 			require("opencode").prompt("@this") ]]
	--[[ 		end, { desc = "Add to opencode" }) ]]
	--[[ 		vim.keymap.set({ "n", "x" }, "<leader>slt", function() ]]
	--[[ 			require("opencode").prompt("@selection") ]]
	--[[ 		end, { desc = "Add selection" }) ]]
	--[[ 		vim.keymap.set({ "n", "t" }, "<leader>tgl", function() ]]
	--[[ 			require("opencode").start() ]]
	--[[ 		end, { desc = "Toggle opencode" }) ]]
	--[[ 		vim.keymap.set("n", "<leader>ssn", function() ]]
	--[[ 			require("opencode").command("session.new") ]]
	--[[ 		end, { desc = "New session" }) ]]
	--[[ 		vim.keymap.set("n", "<leader>ssl", function() ]]
	--[[ 			require("opencode").command("session.list") ]]
	--[[ 		end, { desc = "List sessions" }) ]]
	--[[ 		vim.keymap.set("n", "<S-C-k>", function() ]]
	--[[ 			require("opencode").command("session.half.page.up") ]]
	--[[ 		end, { desc = "opencode page up" }) ]]
	--[[ 		vim.keymap.set("n", "<S-C-j>", function() ]]
	--[[ 			require("opencode").command("session.half.page.down") ]]
	--[[ 		end, { desc = "opencode page down" }) ]]
	--[[ 	end, ]]
	--[[ }, ]]
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = function()
			require("claudecode").setup({
				terminal = {
					split_side = "right",
					split_width_percentage = 0.5,
				},
			})

			vim.o.autoread = true

			vim.keymap.set({ "n", "t" }, "<leader>tgl", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
			vim.keymap.set("n", "<leader>ask", "<cmd>ClaudeCodeFocus<cr>", { desc = "Ask (focus Claude)" })
			vim.keymap.set("n", "<leader>ths", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add buffer to Claude" })
			vim.keymap.set("x", "<leader>slt", "<cmd>ClaudeCodeSend<cr>", { desc = "Add selection to Claude" })
			vim.keymap.set("n", "<leader>cmd", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select model" })
			vim.keymap.set("n", "<leader>ssn", function()
				vim.cmd("ClaudeCodeStop")
				vim.cmd("ClaudeCode")
			end, { desc = "New Claude session" })
			vim.keymap.set("n", "<leader>ssl", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude session" })
		end,
	},
}, {
	ui = { border = "rounded" },
})
